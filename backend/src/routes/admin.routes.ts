import { Router } from 'express';
import { createPost, createSeries, deletePost } from '../controllers/admin.controller';
import { authenticateToken } from '../middleware/auth.middleware';
import { adminOnly } from '../middleware/adminOnly.middleware';

const router = Router();

router.use(authenticateToken, adminOnly);

router.post('/posts', createPost);
router.post('/series', createSeries);
router.delete('/posts/:id', deletePost);

export default router;