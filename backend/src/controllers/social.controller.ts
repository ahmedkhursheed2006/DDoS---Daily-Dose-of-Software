import { Response } from 'express';
import pool from '../config/database';
import { AuthenticatedRequest } from '../middleware/auth.middleware';

export const getCommentsByPost = async (req: AuthenticatedRequest, res: Response) => {
  const { postId } = req.params;

  try {
    const result = await pool.query(
      `SELECT c.id, c.post_id as "postId", c.content, c.created_at as "createdAt", u.name as "authorName"
       FROM comments c
       JOIN users u ON c.user_id = u.id
       WHERE c.post_id = $1
       ORDER BY c.created_at DESC`,
      [postId]
    );

    res.status(200).json({ comments: result.rows });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch comments' });
  }
};

export const addComment = async (req: AuthenticatedRequest, res: Response) => {
  const { postId, content } = req.body;
  const userId = req.user?.id;

  if (!postId || !content) {
    return res.status(400).json({ error: 'Post ID and content are required' });
  }

  try {
    const result = await pool.query(
      `INSERT INTO comments (post_id, user_id, content)
       VALUES ($1, $2, $3)
       RETURNING id, post_id as "postId", content, created_at as "createdAt"`,
      [postId, userId, content]
    );

    res.status(201).json({ data: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: 'Failed to post comment' });
  }
};