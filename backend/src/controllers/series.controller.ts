import { Request, Response } from 'express';
import pool from '../config/database';

export const getAllSeries = async (req: Request, res: Response) => {
  try {
    const result = await pool.query(`
      SELECT s.*, COUNT(p.id)::int as "totalPosts"
      FROM series s
      LEFT JOIN posts p ON s.id = p.series_id
      GROUP BY s.id
      ORDER BY s.created_at DESC
    `);
    res.status(200).json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch series' });
  }
};

export const getSeriesById = async (req: Request, res: Response) => {
  const { id } = req.params;
  try {
    const seriesResult = await pool.query('SELECT * FROM series WHERE id = $1', [id]);
    if (seriesResult.rows.length === 0) {
      return res.status(404).json({ error: 'Series not found' });
    }

    const postsResult = await pool.query(
      'SELECT id, title, content, category, read_time_minutes as "readTimeMinutes", created_at as "createdAt" FROM posts WHERE series_id = $1 ORDER BY created_at ASC',
      [id]
    );

    const series = seriesResult.rows[0];
    series.posts = postsResult.rows;

    res.status(200).json({ data: series });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch series details' });
  }
};