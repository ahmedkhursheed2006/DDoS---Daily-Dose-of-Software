"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const series_controller_1 = require("../controllers/series.controller");
const router = (0, express_1.Router)();
router.get('/', series_controller_1.getAllSeries);
router.get('/:id', series_controller_1.getSeriesById);
exports.default = router;
