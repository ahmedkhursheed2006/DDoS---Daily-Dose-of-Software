import express from "express";
import cors from "cors";
import seriesRoutes from "./routes/series.routes";
import followRoutes from "./routes/follow.routes";
import feedRoutes from "./routes/feed.routes";
import authRoutes from "./routes/auth.routes";

const app = express();

app.use(cors());
app.use(express.json());

app.use("/series", seriesRoutes);
app.use("/series", followRoutes);
app.use("/feed", feedRoutes);

// Task 5 Auth routes
app.use("/api/auth", authRoutes);

app.get("/", (_req, res) => {
  res.json({
    message: "DDoS T6 Backend is running",
  });
});

app.get("/api/health", (_req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

export default app;