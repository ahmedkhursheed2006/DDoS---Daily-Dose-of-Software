import { Router } from 'express';
import { authenticateToken } from '../middleware/auth.middleware';
import { getPost, getSavedPosts, markRead, toggleLike, toggleSave } from '../controllers/post.controller';
import { addComment, getCommentsByPost } from '../controllers/social.controller';
import { createRepost } from '../controllers/repost.controller';

const router = Router();

router.use(authenticateToken);
router.get('/saved', getSavedPosts);
router.get('/:id', getPost);
router.post('/:id/read', markRead);
router.post('/:id/save', toggleSave);
router.post('/:id/like', toggleLike);
router.get('/:id/comments', getCommentsByPost);
router.post('/:id/comments', addComment);
router.post('/:id/repost', createRepost);

export default router;
