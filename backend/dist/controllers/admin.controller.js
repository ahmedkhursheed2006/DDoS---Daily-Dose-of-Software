"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePost = exports.createSeries = exports.createPost = void 0;
const database_1 = __importDefault(require("../config/database"));
const createPost = async (req, res) => {
    const { title, content, category, readTimeMinutes, seriesId } = req.body;
    try {
        const result = await database_1.default.query(`INSERT INTO posts (title, content, category, read_time_minutes, series_id)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, title, content, category, read_time_minutes as "readTimeMinutes", series_id as "seriesId", created_at as "createdAt"`, [title, content, category, readTimeMinutes || 3, seriesId || null]);
        res.status(201).json({ data: result.rows[0] });
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to create post' });
    }
};
exports.createPost = createPost;
const createSeries = async (req, res) => {
    const { title, description, category } = req.body;
    try {
        const result = await database_1.default.query(`INSERT INTO series (title, description, category)
       VALUES ($1, $2, $3)
       RETURNING id, title, description, category, created_at as "createdAt"`, [title, description, category]);
        res.status(201).json({ data: result.rows[0] });
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to create series' });
    }
};
exports.createSeries = createSeries;
const deletePost = async (req, res) => {
    const { id } = req.params;
    try {
        await database_1.default.query('DELETE FROM posts WHERE id = $1', [id]);
        res.status(200).json({ message: 'Post deleted successfully' });
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to delete post' });
    }
};
exports.deletePost = deletePost;
