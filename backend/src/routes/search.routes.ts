import { Router } from 'express';
import { searchPosts } from '../controllers/search.controller';

const router = Router();

router.get('/', searchPosts);

export default router;