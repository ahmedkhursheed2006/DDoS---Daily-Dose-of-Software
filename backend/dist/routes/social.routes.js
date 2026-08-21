"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const social_controller_1 = require("../controllers/social.controller");
const auth_middleware_1 = require("../middleware/auth.middleware");
const router = (0, express_1.Router)();
router.get('/comments/:postId', social_controller_1.getCommentsByPost);
router.post('/comments', auth_middleware_1.authenticateToken, social_controller_1.addComment);
exports.default = router;
