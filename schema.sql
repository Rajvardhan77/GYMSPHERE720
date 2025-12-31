-- Enable UUID extension if needed (optional but good practice)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    fullname VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    age INTEGER,
    height_cm FLOAT,
    weight_kg FLOAT,
    target_weight_kg FLOAT,
    body_level VARCHAR(50),
    activity_level VARCHAR(50),
    fitness_level VARCHAR(50),
    freq_per_week INTEGER,
    goal VARCHAR(100),
    estimate_days INTEGER,
    last_check_date TIMESTAMP,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL,
    workout_streak INTEGER DEFAULT 0,
    diet_streak INTEGER DEFAULT 0,
    last_workout_date DATE,
    last_diet_date DATE,
    is_admin BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Diet Plans Table
CREATE TABLE IF NOT EXISTS diet_plans (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    calories INTEGER,
    protein FLOAT,
    carbs FLOAT,
    fats FLOAT,
    goal VARCHAR(100),
    description TEXT
);

-- Products Table
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    category VARCHAR(100),
    description TEXT,
    image_url VARCHAR(500),
    equipment_type VARCHAR(50),
    neon_border_color VARCHAR(20),
    affiliate_url VARCHAR(500),
    rating FLOAT DEFAULT 4.5,
    src VARCHAR(50) DEFAULT 'local'
);

-- Exercises Table
CREATE TABLE IF NOT EXISTS exercises (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    muscle_group VARCHAR(50),
    difficulty VARCHAR(20),
    equipment VARCHAR(100),
    description TEXT,
    animation_type VARCHAR(20),
    animation_url VARCHAR(500),
    thumbnail_url VARCHAR(500),
    tags VARCHAR(200)
);

-- Water Logs Table
CREATE TABLE IF NOT EXISTS water_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date DATE DEFAULT CURRENT_DATE NOT NULL,
    amount_ml INTEGER DEFAULT 0,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_water_logs_user_id ON water_logs(user_id);

-- Sleep Logs Table
CREATE TABLE IF NOT EXISTS sleep_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date DATE DEFAULT CURRENT_DATE NOT NULL,
    hours FLOAT DEFAULT 0.0,
    quality VARCHAR(20)
);

CREATE INDEX IF NOT EXISTS idx_sleep_logs_user_id ON sleep_logs(user_id);

-- Badges Table
CREATE TABLE IF NOT EXISTS badges (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    icon VARCHAR(50),
    description VARCHAR(200),
    criteria_json JSON
);

-- User Badges Table
CREATE TABLE IF NOT EXISTS user_badges (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_id INTEGER NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
    earned_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

-- User Progress Table
CREATE TABLE IF NOT EXISTS user_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    weight FLOAT,
    logged_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL
);

-- Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) DEFAULT 'info',
    title VARCHAR(200) NOT NULL,
    message TEXT,
    payload_json JSON,
    scheduled_for TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total_amount NUMERIC(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);

-- User Plans Table
CREATE TABLE IF NOT EXISTS user_plans (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    plan_type VARCHAR(50) DEFAULT 'workout+diet',
    goal VARCHAR(100),
    preference VARCHAR(50),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    frequency_per_week INTEGER,
    fitness_level VARCHAR(50),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    metadata_json JSON
);

CREATE INDEX IF NOT EXISTS idx_user_plans_user_id ON user_plans(user_id);

-- Daily Plan Entries Table
CREATE TABLE IF NOT EXISTS daily_plan_entries (
    id SERIAL PRIMARY KEY,
    plan_id INTEGER NOT NULL REFERENCES user_plans(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    is_exercise_day BOOLEAN DEFAULT FALSE,
    exercise_payload JSON,
    diet_payload JSON,
    is_exercise_completed BOOLEAN DEFAULT FALSE,
    exercise_completed_at TIMESTAMP WITHOUT TIME ZONE,
    is_diet_completed BOOLEAN DEFAULT FALSE,
    diet_completed_at TIMESTAMP WITHOUT TIME ZONE,
    streak_group INTEGER
);

CREATE INDEX IF NOT EXISTS idx_plan_date ON daily_plan_entries(plan_id, date);

-- User Check-Ins Table
CREATE TABLE IF NOT EXISTS user_checkins (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    daily_entry_id INTEGER NOT NULL REFERENCES daily_plan_entries(id) ON DELETE CASCADE,
    type VARCHAR(20),
    timestamp TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    note TEXT
);

CREATE INDEX IF NOT EXISTS idx_user_checkins_user_id ON user_checkins(user_id);
