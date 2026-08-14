import { FeedRepository } from "../repositories/feed.repository";

export class FeedService {
  private repository = new FeedRepository();

  async getTodayFeed(userId: number) {
    return this.repository.getTodayFeed(userId);
  }
}