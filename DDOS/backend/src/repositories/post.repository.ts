export class PostRepository {
  async findNextUnreadPost(userId: number, seriesId: number) {
    // PostgreSQL query will be connected once the shared DB/schema is ready.
    return {
      userId,
      seriesId,
      message: "Next unread post will be fetched from PostgreSQL",
    };
  }
}