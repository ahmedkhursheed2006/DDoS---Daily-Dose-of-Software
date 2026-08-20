export class PostRepository {
    async getFollowedSeries(userId: number) {
  return [1, 2];
}
  async findNextUnreadPost(userId: number, seriesId: number) {
    const posts = [
      { id: 101, seriesId: 1, positionInSeries: 1, read: true },
      { id: 102, seriesId: 1, positionInSeries: 2, read: false },
      { id: 103, seriesId: 1, positionInSeries: 3, read: false },
    ];

    const nextPost = posts
      .filter(
        (post) =>
          post.seriesId === seriesId &&
          post.read === false
      )
      .sort((a, b) => a.positionInSeries - b.positionInSeries)[0];

    return {
      userId,
      seriesId,
      post: nextPost ?? null,
    };
  }
}