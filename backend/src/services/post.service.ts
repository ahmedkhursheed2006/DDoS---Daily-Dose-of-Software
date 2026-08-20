import { PostRepository } from "../repositories/post.repository";

export class PostService {
  private repository = new PostRepository();

  async nextPostFor(userId: number, seriesId: number) {
    return this.repository.findNextUnreadPost(userId, seriesId);
  }
}