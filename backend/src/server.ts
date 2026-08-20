import express from "express";
import cors from "cors";
import seriesRoutes from "./routes/series.routes";
import followRoutes from "./routes/follow.routes";
import feedRoutes from "./routes/feed.routes";

const app = express();

app.use(cors());
app.use(express.json());

app.use("/series", seriesRoutes);
app.use("/series", followRoutes);
app.use("/feed", feedRoutes);
app.get("/", (_req, res) => {
  res.json({
    message: "DDoS T6 Backend is running",
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});