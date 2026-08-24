import { Response } from 'express';
import pool from '../config/database';
import { AuthenticatedRequest } from '../middleware/auth.middleware';

export const createRepost = async (req: AuthenticatedRequest, res: Response) => {
  const { id: postId } = req.params;
  const { commentary } = req.body;
  const userId = req.user?.id;

  try {
    const result = await pool.query(
      `INSERT INTO reposts (user_id, post_id, commentary_text)
       VALUES ($1, $2, NULLIF($3, ''))
       RETURNING id, user_id as "userId", post_id as "postId", commentary_text as commentary, created_at as "createdAt"`,
      [userId, postId, commentary ?? ''],
    );
    return res.status(201).json(result.rows[0]);
  } catch (error) {
    return res.status(500).json({ error: 'Failed to create repost' });
  }
};

export const getReposts = async (_req: AuthenticatedRequest, res: Response) => {
  try {
    const result = await pool.query(
      `SELECT r.id, r.user_id as "userId", u.name as "userName", r.post_id as "postId",
              r.commentary_text as commentary, r.created_at as "createdAt",
              p.title as "originalTitle", p.content as "originalContent", p.image_url as "imageUrl"
       FROM reposts r
       JOIN users u ON u.id = r.user_id
       JOIN posts p ON p.id = r.post_id
       ORDER BY r.created_at DESC`,
    );
    return res.json({ reposts: result.rows });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to fetch reposts' });
  }
};

export const toggleRepostLike = async (req: AuthenticatedRequest, res: Response) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const existing = await client.query(
      'SELECT 1 FROM repost_likes WHERE user_id = $1 AND repost_id = $2',
      [req.user?.id, req.params.id],
    );
    if (existing.rowCount) {
      await client.query('DELETE FROM repost_likes WHERE user_id = $1 AND repost_id = $2', [req.user?.id, req.params.id]);
    } else {
      await client.query('INSERT INTO repost_likes (user_id, repost_id) VALUES ($1, $2)', [req.user?.id, req.params.id]);
    }
    await client.query('COMMIT');
    return res.json({ liked: !existing.rowCount });
  } catch (error) {
    await client.query('ROLLBACK');
    return res.status(500).json({ error: 'Failed to toggle repost like' });
  } finally {
    client.release();
  }
};

export const addRepostComment = async (req: AuthenticatedRequest, res: Response) => {
  const { content } = req.body;
  if (!content?.trim()) return res.status(400).json({ error: 'Comment content is required' });
  try {
    const result = await pool.query(
      `INSERT INTO repost_comments (user_id, repost_id, content)
       VALUES ($1, $2, $3)
       RETURNING id, user_id as "userId", repost_id as "repostId", content, created_at as "createdAt"`,
      [req.user?.id, req.params.id, content.trim()],
    );
    return res.status(201).json(result.rows[0]);
  } catch (error) {
    return res.status(500).json({ error: 'Failed to add repost comment' });
  }
};
