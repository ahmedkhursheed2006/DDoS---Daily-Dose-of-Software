import { Router } from "express";
import { getTodayFeed } from "../controllers/feed.controller";

const router = Router();

router.get("/today", getTodayFeed);

export default router;