import { Response } from 'express';
import { FeedService } from '../services/feed.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';

const feedService = new FeedService();

export const getTodayFeed = async (req: AuthenticatedRequest, res: Response) => {
  try {
    const userId = Number(req.user?.id);
    if (Number.isNaN(userId)) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const result = await feedService.getTodayFeed(userId);
    return res.json(result);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Failed to fetch today's feed" });
  }
};
