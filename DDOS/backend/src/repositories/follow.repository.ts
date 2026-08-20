export class FollowRepository {
  async toggleFollow(userId: number, seriesId: number) {
    // PostgreSQL integration will be added once the shared DB/schema is ready.
    return {
      userId,
      seriesId,
      following: true,
    };
  }
}