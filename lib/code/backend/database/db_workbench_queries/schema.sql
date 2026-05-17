 
CREATE DATABASE IF NOT EXISTS paper_checking;
-- ========================================
-- AI Paper Checking System — Database Setup
-- ========================================
 use paper_checking;
-- ── Users (shared for teacher & student) ──
CREATE TABLE IF NOT EXISTS users (
  user_id       INT AUTO_INCREMENT PRIMARY KEY,
  first_name    VARCHAR(50)  NOT NULL,
  last_name     VARCHAR(50)  NOT NULL,
  email         VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  cnic          VARCHAR(15)  UNIQUE NOT NULL,
  gender        ENUM('male','female') NOT NULL,
  role          ENUM('teacher','student') NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── Teacher Profiles ──
CREATE TABLE IF NOT EXISTS teacher_profiles (
  profile_id       INT AUTO_INCREMENT PRIMARY KEY,
  user_id          INT UNIQUE NOT NULL,
  school_name      VARCHAR(100),
  education        VARCHAR(100),
  degree           VARCHAR(100),
  description      TEXT,
  experience_years INT,
  phone_number     VARCHAR(20),
  profile_picture  VARCHAR(255),
  updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ── Student Profiles ──
CREATE TABLE IF NOT EXISTS student_profiles (
  profile_id       INT AUTO_INCREMENT PRIMARY KEY,
  user_id          INT UNIQUE NOT NULL,
  roll_number      VARCHAR(50),
  department       VARCHAR(100),
  semester         INT,
  institution_name VARCHAR(100),
  phone_number     VARCHAR(20),
  profile_picture  VARCHAR(255),
  updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);