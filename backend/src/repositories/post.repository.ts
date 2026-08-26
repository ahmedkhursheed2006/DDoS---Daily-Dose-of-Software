import pool from '../config/database';

export class PostRepository {
  /**
   * Returns the lowest-position unread post in the given series for the given user.
   * Implements SRS FR-06: "today's post" = lowest-position post not yet read.
   */
  async findNextUnreadPost(userId: number, seriesId: number) {
    const result = await pool.query(
      `SELECT
         p.id,
         p.series_id          AS "seriesId",
         s.title              AS "seriesTitle",
         p.title,
         p.content,
         p.image_url          AS "imageUrl",
         p.source_reference   AS "sourceReference",
         p.position_in_series AS "positionInSeries",
         p.read_time_minutes  AS "readTimeMinutes"
       FROM posts p
       JOIN series s ON s.id = p.series_id
       LEFT JOIN read_receipts rr
         ON rr.post_id = p.id AND rr.user_id = $1
       WHERE p.series_id = $2
         AND rr.post_id IS NULL
       ORDER BY p.position_in_series ASC
       LIMIT 1`,
      [userId, seriesId],
    );

    return result.rows[0] ?? null;
  }
}
