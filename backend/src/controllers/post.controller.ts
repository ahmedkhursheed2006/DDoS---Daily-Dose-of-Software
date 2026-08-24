import { Response } from 'express';
import pool from '../config/database';
import { AuthenticatedRequest } from '../middleware/auth.middleware';

const postId = (req: AuthenticatedRequest) => req.params.id;
const userId = (req: AuthenticatedRequest) => req.user?.id;

export const getPost = async (req: AuthenticatedRequest, res: Response) => {
  try {
    const result = await pool.query(
      `SELECT p.id, p.series_id as "seriesId", p.title, p.content, p.image_url as "imageUrl",
              p.source_reference as "sourceReference", p.position_in_series as "positionInSeries",
              p.read_time_minutes as "readTimeMinutes", p.created_at as "createdAt",
              EXISTS (SELECT 1 FROM likes l WHERE l.post_id = p.id AND l.user_id = $2) as "isLiked",
              EXISTS (SELECT 1 FROM saved_posts s WHERE s.post_id = p.id AND s.user_id = $2) as "isSaved",
              (SELECT COUNT(*)::int FROM likes l WHERE l.post_id = p.id) as "likeCount"
       FROM posts p WHERE p.id = $1`,
      [postId(req), userId(req)],
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Post not found' });

    await pool.query(
      `INSERT INTO read_receipts (user_id, post_id) VALUES ($1, $2)
       ON CONFLICT (user_id, post_id) DO NOTHING`,
      [userId(req), postId(req)],
    );
    return res.json(result.rows[0]);
  } catch (error) {
    console.error('Get post error:', error);
    return res.status(500).json({ error: 'Failed to fetch post' });
  }
};

export const getSavedPosts = async (req: AuthenticatedRequest, res: Response) => {
  try {
    const result = await pool.query(
      `SELECT p.id, p.series_id as "seriesId", p.title, p.content, p.image_url as "imageUrl",
              p.source_reference as "sourceReference", p.read_time_minutes as "readTimeMinutes",
              sp.saved_at as "savedAt"
       FROM saved_posts sp JOIN posts p ON p.id = sp.post_id
       WHERE sp.user_id = $1 ORDER BY sp.saved_at DESC`,
      [req.user?.id],
    );
    return res.json({ posts: result.rows });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to fetch saved posts' });
  }
};

export const markRead = async (req: AuthenticatedRequest, res: Response) => {
  try {
    await pool.query(
      `INSERT INTO read_receipts (user_id, post_id) VALUES ($1, $2)
       ON CONFLICT (user_id, post_id) DO NOTHING`,
      [userId(req), postId(req)],
    );
    return res.status(204).send();
  } catch (error) {
    return res.status(500).json({ error: 'Failed to mark post as read' });
  }
};

const toggleRelation = async (
  req: AuthenticatedRequest,
  res: Response,
  table: 'likes' | 'saved_posts',
  field: 'liked' | 'saved',
) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const existing = await client.query(
      `SELECT 1 FROM ${table} WHERE user_id = $1 AND post_id = $2`,
      [userId(req), postId(req)],
    );
    if (existing.rowCount) {
      await client.query(`DELETE FROM ${table} WHERE user_id = $1 AND post_id = $2`, [userId(req), postId(req)]);
    } else {
      await client.query(`INSERT INTO ${table} (user_id, post_id) VALUES ($1, $2)`, [userId(req), postId(req)]);
    }
    await client.query('COMMIT');
    return res.json({ [field]: !existing.rowCount });
  } catch (error) {
    await client.query('ROLLBACK');
    return res.status(500).json({ error: `Failed to toggle ${field}` });
  } finally {
    client.release();
  }
};

export const toggleLike = (req: AuthenticatedRequest, res: Response) =>
  toggleRelation(req, res, 'likes', 'liked');

export const toggleSave = (req: AuthenticatedRequest, res: Response) =>
  toggleRelation(req, res, 'saved_posts', 'saved');
