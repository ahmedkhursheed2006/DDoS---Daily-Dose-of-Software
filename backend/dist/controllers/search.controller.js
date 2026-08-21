"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.searchPosts = void 0;
const database_1 = __importDefault(require("../config/database"));
const searchPosts = async (req, res) => {
    const query = req.query.q;
    if (!query || query.trim() === '') {
        return res.status(200).json({ posts: [] });
    }
    try {
        const searchTerm = `%${query.trim()}%`;
        const result = await database_1.default.query(`SELECT id, title, content, category, read_time_minutes as "readTimeMinutes", created_at as "createdAt"
       FROM posts
       WHERE title ILIKE $1 OR content ILIKE $1 OR category ILIKE $1
       ORDER BY created_at DESC`, [searchTerm]);
        res.status(200).json({ posts: result.rows });
    }
    catch (error) {
        res.status(500).json({ error: 'Search failed' });
    }
};
exports.searchPosts = searchPosts;
