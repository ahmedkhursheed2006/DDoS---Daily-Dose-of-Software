import { Router } from 'express';
import { getAllSeries, getSeriesById } from '../controllers/series.controller';

const router = Router();

router.get('/', getAllSeries);
router.get('/:id', getSeriesById);

export default router;