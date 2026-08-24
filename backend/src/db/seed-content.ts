import fs from 'node:fs/promises';
import path from 'node:path';
import pool from '../config/database';

const contentDirectory = path.resolve(__dirname, '../../../lib/content');
const seriesTitle = 'Daily Dose of Software';
const seriesDescription = 'Short, curated lessons about the systems behind modern software.';
const seriesCategory = 'ENGINEERING';

function lessonPosition(filename: string): number {
  const match = filename.match(/^day-(\d+)-/);
  if (!match) throw new Error(`Content filename must start with day-NN: ${filename}`);
  return Number(match[1]);
}

function lessonTitle(markdown: string, filename: string): string {
  const heading = markdown.match(/^#\s+(.+)$/m)?.[1]?.trim();
  if (!heading) throw new Error(`Content file has no H1 title: ${filename}`);
  return heading;
}

async function seedContent() {
  const files = (await fs.readdir(contentDirectory))
    .filter((file) => file.endsWith('.md'))
    .sort((left, right) => lessonPosition(left) - lessonPosition(right));

  if (files.length === 0) throw new Error(`No Markdown lessons found in ${contentDirectory}`);

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const seriesResult = await client.query(
      `INSERT INTO series (title, description, category, is_active)
       VALUES ($1, $2, $3, TRUE)
       ON CONFLICT (title) DO UPDATE SET description = EXCLUDED.description, category = EXCLUDED.category, is_active = TRUE
       RETURNING id`,
      [seriesTitle, seriesDescription, seriesCategory],
    );
    const seriesId = seriesResult.rows[0].id;

    for (const filename of files) {
      const markdown = await fs.readFile(path.join(contentDirectory, filename), 'utf8');
      const position = lessonPosition(filename);
      const title = lessonTitle(markdown, filename);
      await client.query(
        `INSERT INTO posts (series_id, title, content, source_reference, position_in_series, read_time_minutes)
         VALUES ($1, $2, $3, $4, $5, 5)
         ON CONFLICT (series_id, position_in_series) DO UPDATE SET
           title = EXCLUDED.title,
           content = EXCLUDED.content,
           source_reference = EXCLUDED.source_reference,
           read_time_minutes = EXCLUDED.read_time_minutes`,
        [seriesId, title, markdown, `lib/content/${filename}`, position],
      );
    }

    await client.query('COMMIT');
    console.log(`Imported ${files.length} Markdown lessons into "${seriesTitle}".`);
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
    await pool.end();
  }
}

seedContent().catch((error) => {
  if (error?.code === '28P01') {
    console.error(
      'Content import failed: PostgreSQL rejected the password for user "postgres". ' +
      'Update DB_PASSWORD in backend/.env to the password chosen during PostgreSQL installation.',
    );
  } else if (error?.code === 'ECONNREFUSED') {
    console.error(
      'Content import failed: PostgreSQL is not reachable at localhost:5432. ' +
      'Start PostgreSQL or run "docker compose up -d postgres" from backend/.',
    );
  } else {
    console.error('Content import failed:', error);
  }
  process.exitCode = 1;
});
