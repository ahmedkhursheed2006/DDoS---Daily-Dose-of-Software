import pool from '../config/database';

export class FollowRepository {
  async toggleFollow(userId: number, seriesId: number): Promise<{ following: boolean }> {
    const existing = await pool.query(
      'SELECT 1 FROM follows WHERE user_id = $1 AND series_id = $2',
      [userId, seriesId],
    );

    if ((existing.rowCount ?? 0) > 0) {
      await pool.query(
        'DELETE FROM follows WHERE user_id = $1 AND series_id = $2',
        [userId, seriesId],
      );
      return { following: false };
    }

    await pool.query(
      'INSERT INTO follows (user_id, series_id) VALUES ($1, $2)',
      [userId, seriesId],
    );
    return { following: true };
  }
}
