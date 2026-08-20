import { Request, Response } from "express";
import { FollowService } from "../services/follow.service";

const service = new FollowService();

export const toggleFollow = async (req: Request, res: Response) => {
  try {
    const seriesId = Number(req.params.id);

    if (Number.isNaN(seriesId)) {
      return res.status(400).json({
        message: "Invalid series id",
      });
    }

    // Temporary user ID until authentication middleware is connected.
    const userId = 1;

    const result = await service.toggleFollow(userId, seriesId);

    return res.json(result);
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      message: "Failed to update follow status",
    });
  }
};