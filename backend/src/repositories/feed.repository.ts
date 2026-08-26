import pool from '../config/database';

export class FeedRepository {
  async getFollowedSeries(userId: number): Promise<number[]> {
    const result = await pool.query(
      'SELECT series_id FROM follows WHERE user_id = $1',
      [userId],
    );
    return result.rows.map((row) => Number(row.series_id));
  }
}
