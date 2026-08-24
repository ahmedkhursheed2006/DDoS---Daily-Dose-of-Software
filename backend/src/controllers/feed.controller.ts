import { Request, Response } from "express";
import pool from '../config/database';
import { AuthenticatedRequest } from '../middleware/auth.middleware';

export const getTodayFeed = async (req: AuthenticatedRequest, res: Response) => {
  try {
    const result = await pool.query(
      `SELECT DISTINCT ON (f.series_id)
              f.series_id as "seriesId", s.title as "seriesTitle", p.id as "postId",
              p.title, p.content, p.image_url as "imageUrl",
              p.source_reference as "sourceReference", p.position_in_series as "positionInSeries",
              p.read_time_minutes as "readTimeMinutes"
       FROM follows f
       JOIN series s ON s.id = f.series_id AND s.is_active = TRUE
       JOIN posts p ON p.series_id = f.series_id
       LEFT JOIN read_receipts rr ON rr.post_id = p.id AND rr.user_id = f.user_id
       WHERE f.user_id = $1 AND rr.post_id IS NULL
       ORDER BY f.series_id, p.position_in_series ASC`,
      [req.user?.id],
    );
    return res.json({ userId: req.user?.id, posts: result.rows });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      message: "Failed to fetch today's feed",
    });
  }
};