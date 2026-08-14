import { Request, Response } from "express";
import { FeedService } from "../services/feed.service";

const service = new FeedService();

export const getTodayFeed = async (_req: Request, res: Response) => {
  try {
    // Temporary user ID until authentication middleware is connected.
    const userId = 1;

    const feed = await service.getTodayFeed(userId);

    return res.json(feed);
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      message: "Failed to fetch today's feed",
    });
  }
};