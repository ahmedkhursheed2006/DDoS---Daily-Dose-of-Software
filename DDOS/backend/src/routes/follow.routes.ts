import { Router } from "express";
import { toggleFollow } from "../controllers/follow.controller";

const router = Router();

router.post("/:id/follow", toggleFollow);

export default router;