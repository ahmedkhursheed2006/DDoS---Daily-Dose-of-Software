import { Response } from 'express';
import pool from '../config/database';
import { AuthenticatedRequest } from '../middleware/auth.middleware';

export const createPost = async (req: AuthenticatedRequest, res: Response) => {
  const { title, content, imageUrl, sourceReference, positionInSeries, readTimeMinutes, seriesId } = req.body;

  if (!title || !content || !sourceReference?.trim() || !seriesId || !positionInSeries) {
    return res.status(400).json({ error: 'title, content, seriesId, positionInSeries, and sourceReference are required' });
  }
  if (!Number.isInteger(readTimeMinutes) || readTimeMinutes < 1 || readTimeMinutes > 5) {
    return res.status(400).json({ error: 'readTimeMinutes must be an integer between 1 and 5' });
  }

  try {
    const result = await pool.query(
      `INSERT INTO posts (title, content, image_url, source_reference, position_in_series, read_time_minutes, series_id)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING id, title, content, image_url as "imageUrl", source_reference as "sourceReference", position_in_series as "positionInSeries", read_time_minutes as "readTimeMinutes", series_id as "seriesId", created_at as "createdAt"`,
      [title, content, imageUrl || null, sourceReference.trim(), positionInSeries, readTimeMinutes, seriesId]
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