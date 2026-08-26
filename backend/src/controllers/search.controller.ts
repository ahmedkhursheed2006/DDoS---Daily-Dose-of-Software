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
      `SELECT p.id, p.title, p.content, p.read_time_minutes AS "readTimeMinutes",
              p.created_at AS "createdAt", s.category
       FROM posts p
       JOIN series s ON s.id = p.series_id
       WHERE p.title ILIKE $1 OR p.content ILIKE $1 OR s.category ILIKE $1
       ORDER BY p.created_at DESC`,
      [searchTerm],
    );

    res.status(200).json({ posts: result.rows });
  } catch (error) {
    res.status(500).json({ error: 'Search failed' });
  }
};