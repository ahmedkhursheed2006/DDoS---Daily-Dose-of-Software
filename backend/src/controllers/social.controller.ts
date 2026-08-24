import { Response } from 'express';
import pool from '../config/database';
import { AuthenticatedRequest } from '../middleware/auth.middleware';

export const getCommentsByPost = async (req: AuthenticatedRequest, res: Response) => {
  const postId = req.params.postId ?? req.params.id;

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
  const postId = req.params.id ?? req.body.postId;
  const { content } = req.body;
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

export const updateComment = async (req: AuthenticatedRequest, res: Response) => {
  const userId = req.user?.id;
  const { id } = req.params;
  const { content } = req.body;
  if (!content?.trim()) return res.status(400).json({ error: 'Comment content is required' });

  const result = await pool.query(
    `UPDATE comments SET content = $1 WHERE id = $2 AND user_id = $3
     RETURNING id, post_id as "postId", content, created_at as "createdAt"`,
    [content.trim(), id, userId],
  );
  if (result.rowCount === 0) return res.status(404).json({ error: 'Comment not found' });
  return res.json(result.rows[0]);
};

export const deleteComment = async (req: AuthenticatedRequest, res: Response) => {
  const result = await pool.query(
    'DELETE FROM comments WHERE id = $1 AND user_id = $2',
    [req.params.id, req.user?.id],
  );
  if (result.rowCount === 0) return res.status(404).json({ error: 'Comment not found' });
  return res.status(204).send();
};