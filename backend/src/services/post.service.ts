import { PostRepository } from '../repositories/post.repository';

export class PostService {
  private repository = new PostRepository();

  /**
   * Returns the next unread post in the series for the given user (FR-06).
   * Returns null if all posts in the series are read.
   */
  async nextPostFor(userId: number, seriesId: number) {
    return this.repository.findNextUnreadPost(userId, seriesId);
  }
}
