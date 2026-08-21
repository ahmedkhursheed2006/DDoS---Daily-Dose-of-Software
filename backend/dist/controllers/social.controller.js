"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.addComment = exports.getCommentsByPost = void 0;
const database_1 = __importDefault(require("../config/database"));
const getCommentsByPost = async (req, res) => {
    const { postId } = req.params;
    try {
        const result = await database_1.default.query(`SELECT c.id, c.post_id as "postId", c.content, c.created_at as "createdAt", u.name as "authorName"
       FROM comments c
       JOIN users u ON c.user_id = u.id
       WHERE c.post_id = $1
       ORDER BY c.created_at DESC`, [postId]);
        res.status(200).json({ comments: result.rows });
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to fetch comments' });
    }
};
exports.getCommentsByPost = getCommentsByPost;
const addComment = async (req, res) => {
    const { postId, content } = req.body;
    const userId = req.user?.id;
    if (!postId || !content) {
        return res.status(400).json({ error: 'Post ID and content are required' });
    }
    try {
        const result = await database_1.default.query(`INSERT INTO comments (post_id, user_id, content)
       VALUES ($1, $2, $3)
       RETURNING id, post_id as "postId", content, created_at as "createdAt"`, [postId, userId, content]);
        res.status(201).json({ data: result.rows[0] });
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to post comment' });
    }
};
exports.addComment = addComment;
