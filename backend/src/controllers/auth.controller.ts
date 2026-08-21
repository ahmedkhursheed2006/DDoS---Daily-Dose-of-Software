import { Request, Response } from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import pool from '../config/database';

const JWT_SECRET = process.env.JWT_SECRET || 'super_secret_jwt_key_ddos_2026';

export const register = async (req: Request, res: Response) => {
  const { name, email, password } = req.body;

  try {
    if (!name || !email || !password) {
      return res.status(400).json({ error: 'Name, email, and password are required.' });
    }

    const existing = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
    if (existing.rows.length > 0) {
      return res.status(400).json({ error: 'User with this email already exists.' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    
    // Explicitly inserting defaults prevents SQL constraints violations
    const result = await pool.query(
      `INSERT INTO users (name, email, password, role, streak_days, concepts_mastered, accuracy) 
       VALUES ($1, $2, $3, 'user', 0, 0, 0.0) 
       RETURNING id, name, email, role, streak_days, concepts_mastered, accuracy`,
      [name, email, hashedPassword]
    );

    const user = result.rows[0];
    const token = jwt.sign({ id: user.id, role: user.role }, JWT_SECRET, { expiresIn: '7d' });

    const rawAccuracy = user.accuracy != null ? parseFloat(user.accuracy) : 0.0;

    return res.status(201).json({
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role || 'user',
        streakDays: user.streak_days ?? 0,
        conceptsMastered: user.concepts_mastered ?? 0,
        accuracy: isNaN(rawAccuracy) ? 0.0 : rawAccuracy
      }
    });
  } catch (error: any) {
    console.error('Registration Database Error:', error.message || error);
    return res.status(500).json({ error: error.message || 'Internal server error' });
  }
};

export const login = async (req: Request, res: Response) => {
  const { email, password } = req.body;

  try {
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required.' });
    }

    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Invalid email or password.' });
    }

    const user = result.rows[0];
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ error: 'Invalid email or password.' });
    }

    const token = jwt.sign({ id: user.id, role: user.role }, JWT_SECRET, { expiresIn: '7d' });
    const rawAccuracy = user.accuracy != null ? parseFloat(user.accuracy) : 0.0;

    return res.status(200).json({
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role || 'user',
        streakDays: user.streak_days ?? 0,
        conceptsMastered: user.concepts_mastered ?? 0,
        accuracy: isNaN(rawAccuracy) ? 0.0 : rawAccuracy
      }
    });
  } catch (error: any) {
    console.error('Login Error:', error.message || error);
    return res.status(500).json({ error: error.message || 'Internal server error' });
  }
};