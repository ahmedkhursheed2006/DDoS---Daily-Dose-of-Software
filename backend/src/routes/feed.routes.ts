import { Router } from "express";
import { getTodayFeed } from "../controllers/feed.controller";
import { authenticateToken } from '../middleware/auth.middleware';
import { getReposts, toggleRepostLike, addRepostComment } from '../controllers/repost.controller';

const router = Router();

router.get("/today", authenticateToken, getTodayFeed);
router.get('/reposts', authenticateToken, getReposts);
router.post('/reposts/:id/like', authenticateToken, toggleRepostLike);
router.post('/reposts/:id/comments', authenticateToken, addRepostComment);

export default router;