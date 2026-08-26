import { Request, Response } from 'express';
import { SeriesService } from '../services/series.service';

const seriesService = new SeriesService();

export const getAllSeries = async (_req: Request, res: Response) => {
  try {
    const series = await seriesService.getAllSeries();
    res.status(200).json(series);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch series' });
  }
};

export const getSeriesById = async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  if (Number.isNaN(id)) {
    return res.status(400).json({ error: 'Invalid series id' });
  }

  try {
    const series = await seriesService.getSeriesById(id);
    if (!series) {
      return res.status(404).json({ error: 'Series not found' });
    }
    res.status(200).json({ data: series });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch series details' });
  }
};
