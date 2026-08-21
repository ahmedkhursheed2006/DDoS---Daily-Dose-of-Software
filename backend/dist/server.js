"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const auth_routes_1 = __importDefault(require("./routes/auth.routes"));
const series_routes_1 = __importDefault(require("./routes/series.routes"));
const search_routes_1 = __importDefault(require("./routes/search.routes"));
const social_routes_1 = __importDefault(require("./routes/social.routes"));
const admin_routes_1 = __importDefault(require("./routes/admin.routes"));
dotenv_1.default.config();
const app = (0, express_1.default)();
const PORT = process.env.PORT || 3000;
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Routes
app.use('/api/auth', auth_routes_1.default);
app.use('/api/series', series_routes_1.default);
app.use('/api/search', search_routes_1.default);
app.use('/api/social', social_routes_1.default);
app.use('/api/admin', admin_routes_1.default);
app.get('/health', (req, res) => {
    res.json({ status: 'OK', timestamp: new Date() });
});
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
// export default app;
