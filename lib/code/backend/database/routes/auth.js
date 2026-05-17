const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const pool = require("../db/connection");

// ── POST /api/auth/signup ──
router.post("/signup", async (req, res) => {
  const { first_name, last_name, email, password, cnic, gender, role } =
    req.body;

  if (
    !first_name ||
    !last_name ||
    !email ||
    !password ||
    !cnic ||
    !gender ||
    !role
  ) {
    return res.status(400).json({ message: "All fields are required." });
  }

  const allowedRoles = ["teacher", "student"];
  const allowedGenders = ["male", "female"];

  if (!allowedRoles.includes(role.toLowerCase())) {
    return res
      .status(400)
      .json({ message: "Role must be teacher or student." });
  }

  if (!allowedGenders.includes(gender.toLowerCase())) {
    return res.status(400).json({ message: "Gender must be male or female." });
  }

  try {
    const [existing] = await pool.query(
      "SELECT user_id FROM users WHERE email = ? OR cnic = ?",
      [email, cnic],
    );

    if (existing.length > 0) {
      return res
        .status(409)
        .json({ message: "Email or CNIC already registered." });
    }

    const password_hash = await bcrypt.hash(password, 10);

    const [result] = await pool.query(
      `INSERT INTO users (first_name, last_name, email, password_hash, cnic, gender, role)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        first_name,
        last_name,
        email,
        password_hash,
        cnic,
        gender.toLowerCase(),
        role.toLowerCase(),
      ],
    );

    const user_id = result.insertId;

    if (role.toLowerCase() === "teacher") {
      await pool.query("INSERT INTO teacher_profiles (user_id) VALUES (?)", [
        user_id,
      ]);
    } else {
      await pool.query("INSERT INTO student_profiles (user_id) VALUES (?)", [
        user_id,
      ]);
    }

    const token = jwt.sign(
      { user_id, role: role.toLowerCase() },
      process.env.JWT_SECRET,
      { expiresIn: "7d" },
    );

    return res.status(201).json({
      message: "Signup successful.",
      token,
      user: {
        user_id,
        first_name,
        last_name,
        email,
        role: role.toLowerCase(),
        gender: gender.toLowerCase(),
      },
    });
  } catch (err) {
    console.error("Signup error:", err);
    return res.status(500).json({ message: "Server error. Please try again." });
  }
});

// ── POST /api/auth/signin ──
router.post("/signin", async (req, res) => {
  const { email, password, role } = req.body; // ✅ role add hua

  if (!email || !password || !role) {
    return res
      .status(400)
      .json({ message: "Email, password and role are required." });
  }

  const allowedRoles = ["teacher", "student"];
  if (!allowedRoles.includes(role.toLowerCase())) {
    return res
      .status(400)
      .json({ message: "Role must be teacher or student." });
  }

  try {
    // ✅ SIRF YAHAN CHANGE — email ke saath role bhi match karo
    const [rows] = await pool.query(
      "SELECT * FROM users WHERE email = ? AND role = ?",
      [email.trim().toLowerCase(), role.toLowerCase()],
    );

    if (rows.length === 0) {
      return res.status(401).json({ message: "Invalid email or password." });
    }

    const user = rows[0];

    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(401).json({ message: "Invalid email or password." });
    }

    const token = jwt.sign(
      { user_id: user.user_id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: "7d" },
    );

    return res.status(200).json({
      message: "Signin successful.",
      token,
      user: {
        user_id: user.user_id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: user.role,
        gender: user.gender,
      },
    });
  } catch (err) {
    console.error("Signin error:", err);
    return res.status(500).json({ message: "Server error. Please try again." });
  }
});

module.exports = router;
