import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
dotenv.config();
import authRoutes from './routes/auth.routes';
import seriesRoutes from './routes/series.routes';
import searchRoutes from './routes/search.routes';
import socialRoutes from './routes/social.routes';
import adminRoutes from './routes/admin.routes';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({
  origin: '*',
  credentials: true,
}));
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/series', seriesRoutes);
app.use('/api/search', searchRoutes);
app.use('/api/social', socialRoutes);
app.use('/api/admin', adminRoutes);

app.get('/health', (req, res) => {
  res.json( { status: 'OK', timestamp: new Date() } );
});

app.listen(PORT, ()=> {
  console.log(`Server running on port ${PORT}`);
});
// export default app;