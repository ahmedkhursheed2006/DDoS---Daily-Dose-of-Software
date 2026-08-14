export class FeedRepository {
  async getTodayFeed(userId: number) {
    // PostgreSQL query will be connected once the shared DB/schema is ready.
    return {
      userId,
      posts: [],
    };
  }
}