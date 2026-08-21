import pool from '../config/database';
import bcrypt from 'bcrypt';

async function seed() {
  try {
    const hashedPassword = await bcrypt.hash('password123', 10);
    
    await pool.query(`
      INSERT INTO users (name, email, password, role)
      VALUES ('Admin User', 'admin@example.com', $1, 'ADMIN')
      ON CONFLICT (email) DO NOTHING;
    `, [hashedPassword]);

    console.log('Database seeded successfully.');
  } catch (error) {
    console.error('Seeding error:', error);
  } finally {
    await pool.end();
  }
}

seed();