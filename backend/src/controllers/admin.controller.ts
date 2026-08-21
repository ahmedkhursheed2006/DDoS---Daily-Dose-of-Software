import { Response } from 'express';
import pool from '../config/database';
import { AuthenticatedRequest } from '../middleware/auth.middleware';

export const createPost = async (req: AuthenticatedRequest, res: Response) => {
  const { title, content, category, readTimeMinutes, seriesId } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO posts (title, content, category, read_time_minutes, series_id)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, title, content, category, read_time_minutes as "readTimeMinutes", series_id as "seriesId", created_at as "createdAt"`,
      [title, content, category, readTimeMinutes || 3, seriesId || null]
    );

    res.status(201).json({ data: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create post' });
  }
};

export const createSeries = async (req: AuthenticatedRequest, res: Response) => {
  const { title, description, category } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO series (title, description, category)
       VALUES ($1, $2, $3)
       RETURNING id, title, description, category, created_at as "createdAt"`,
      [title, description, category]
    );

    res.status(201).json({ data: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create series' });
  }
};

export const deletePost = async (req: AuthenticatedRequest, res: Response) => {
  const { id } = req.params;

  try {
    await pool.query('DELETE FROM posts WHERE id = $1', [id]);
    res.status(200).json({ message: 'Post deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to delete post' });
  }
};