import { Router } from 'express';
import { getCommentsByPost, addComment } from '../controllers/social.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.get('/comments/:postId', getCommentsByPost);
router.post('/comments', authenticateToken, addComment);

export default router;