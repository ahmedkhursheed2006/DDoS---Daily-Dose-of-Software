import pool from '../config/database';

export class SeriesRepository {
  async findAll() {
    const result = await pool.query(
      `SELECT s.id, s.title, s.description, s.category, s.is_active AS "isActive",
              COUNT(p.id)::int AS "totalPosts"
       FROM series s
       LEFT JOIN posts p ON p.series_id = s.id
       WHERE s.is_active = TRUE
       GROUP BY s.id
       ORDER BY s.created_at DESC`,
    );
    return result.rows;
  }

  async findById(id: number) {
    const seriesResult = await pool.query(
      'SELECT * FROM series WHERE id = $1',
      [id],
    );
    if (seriesResult.rows.length === 0) return null;

    const postsResult = await pool.query(
      `SELECT id, title, content, source_reference AS "sourceReference",
              read_time_minutes AS "readTimeMinutes", position_in_series AS "positionInSeries",
              created_at AS "createdAt"
       FROM posts WHERE series_id = $1 ORDER BY position_in_series ASC`,
      [id],
    );

    const series = seriesResult.rows[0];
    series.posts = postsResult.rows;
    return series;
  }
}
