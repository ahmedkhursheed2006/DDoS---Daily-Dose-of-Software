import { Response } from 'express';
import { FollowService } from '../services/follow.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';

export const toggleFollow = async (req: AuthenticatedRequest, res: Response) => {
  try {
    const seriesId = Number(req.params.id);

    if (Number.isNaN(seriesId)) {
      return res.status(400).json({
        message: "Invalid series id",
      });
    }

    if (!req.user?.id) {
      return res.status(401).json({
        message: "Unauthorized",
      });
    }

    const userId = Number(req.user.id);

    if (Number.isNaN(userId)) {
      return res.status(400).json({
        message: "Invalid user id",
      });
    }

    const result = await new FollowService().toggleFollow(userId, seriesId);
    return res.json({ following: result.following });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      message: "Failed to update follow status",
    });
  }
};
