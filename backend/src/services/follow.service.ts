import { FollowRepository } from "../repositories/follow.repository";

export class FollowService {
  private repository = new FollowRepository();

  async toggleFollow(userId: number, seriesId: number) {
    return this.repository.toggleFollow(userId, seriesId);
  }
}