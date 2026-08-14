import { FeedRepository } from "../repositories/feed.repository";
import { PostService } from "./post.service";

export class FeedService {
  private repository = new FeedRepository();
  private postService = new PostService();

  async getTodayFeed(userId: number) {
    const followedSeries = await this.repository.getFollowedSeries(userId);

    const posts = await Promise.all(
      followedSeries.map((seriesId) =>
        this.postService.nextPostFor(userId, seriesId)
      )
    );

    return {
      userId,
      posts: posts.filter((post) => post !== null),
    };
  }
}