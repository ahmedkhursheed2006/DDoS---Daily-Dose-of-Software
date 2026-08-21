"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getSeriesById = exports.getAllSeries = void 0;
const database_1 = __importDefault(require("../config/database"));
const getAllSeries = async (req, res) => {
    try {
        const result = await database_1.default.query(`
      SELECT s.*, COUNT(p.id)::int as "totalPosts"
      FROM series s
      LEFT JOIN posts p ON s.id = p.series_id
      GROUP BY s.id
      ORDER BY s.created_at DESC
    `);
        res.status(200).json({ data: result.rows });
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to fetch series' });
    }
};
exports.getAllSeries = getAllSeries;
const getSeriesById = async (req, res) => {
    const { id } = req.params;
    try {
        const seriesResult = await database_1.default.query('SELECT * FROM series WHERE id = $1', [id]);
        if (seriesResult.rows.length === 0) {
            return res.status(404).json({ error: 'Series not found' });
        }
        const postsResult = await database_1.default.query('SELECT id, title, content, category, read_time_minutes as "readTimeMinutes", created_at as "createdAt" FROM posts WHERE series_id = $1 ORDER BY created_at ASC', [id]);
        const series = seriesResult.rows[0];
        series.posts = postsResult.rows;
        res.status(200).json({ data: series });
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to fetch series details' });
    }
};
exports.getSeriesById = getSeriesById;
