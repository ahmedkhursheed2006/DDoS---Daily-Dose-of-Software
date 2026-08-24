import { Router } from 'express';
import { getCommentsByPost, addComment, updateComment, deleteComment } from '../controllers/social.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.get('/comments/:postId', authenticateToken, getCommentsByPost);
router.post('/comments', authenticateToken, addComment);
router.patch('/comments/:id', authenticateToken, updateComment);
router.delete('/comments/:id', authenticateToken, deleteComment);

export default router;