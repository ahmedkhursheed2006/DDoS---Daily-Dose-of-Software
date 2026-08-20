import { Request, Response } from "express";
import { SeriesService } from "../services/series.service";

const service = new SeriesService();

export const getSeries = async (_req: Request, res: Response) => {
  try {
    const series = await service.getAllSeries();

    res.json(series);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Failed to fetch series",
    });
  }
};