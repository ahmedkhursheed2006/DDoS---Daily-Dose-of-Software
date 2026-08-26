import { SeriesRepository } from "../repositories/series.repository";
import { PostService } from "./post.service";

export class SeriesService {
  private repository = new SeriesRepository();

  async getAllSeries() {
    return this.repository.findAll();
  }

  async getSeriesById(id: number) {
    return this.repository.findById(id);
  }

  async nextPostFor(userId: number, seriesId: number) {
    const postService = new PostService();
    return postService.nextPostFor(userId, seriesId);
  }
}
