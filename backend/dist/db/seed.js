"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const database_1 = __importDefault(require("../config/database"));
const bcrypt_1 = __importDefault(require("bcrypt"));
async function seed() {
    try {
        const hashedPassword = await bcrypt_1.default.hash('password123', 10);
        await database_1.default.query(`
      INSERT INTO users (name, email, password, role)
      VALUES ('Admin User', 'admin@example.com', $1, 'ADMIN')
      ON CONFLICT (email) DO NOTHING;
    `, [hashedPassword]);
        console.log('Database seeded successfully.');
    }
    catch (error) {
        console.error('Seeding error:', error);
    }
    finally {
        await database_1.default.end();
    }
}
seed();
