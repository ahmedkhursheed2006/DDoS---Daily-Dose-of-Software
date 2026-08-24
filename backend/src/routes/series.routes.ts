import { Router } from 'express';
import { getAllSeries, getSeriesById } from '../controllers/series.controller';
import { authenticateToken } from '../middleware/auth.middleware';
import { toggleFollow } from '../controllers/follow.controller';

const router = Router();

router.get('/', getAllSeries);
router.get('/:id', getSeriesById);
router.post('/:id/follow', authenticateToken, toggleFollow);

export default router;