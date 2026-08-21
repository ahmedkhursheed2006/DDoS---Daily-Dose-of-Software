import { Request, Response } from 'express';
import pool from '../config/database';

export const searchPosts = async (req: Request, res: Response) => {
  const query = req.query.q as string;

  if (!query || query.trim() === '') {
    return res.status(200).json({ posts: [] });
  }

  try {
    const searchTerm = `%${query.trim()}%`;
    const result = await pool.query(
      `SELECT id, title, content, category, read_time_minutes as "readTimeMinutes", created_at as "createdAt"
       FROM posts
       WHERE title ILIKE $1 OR content ILIKE $1 OR category ILIKE $1
       ORDER BY created_at DESC`,
      [searchTerm]
    );

    res.status(200).json({ posts: result.rows });
  } catch (error) {
    res.status(500).json({ error: 'Search failed' });
  }
};