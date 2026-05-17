const express = require("express");
const router = express.Router();
const pool = require("../db/connection");
const jwt = require("jsonwebtoken");

// ── Middleware: verify JWT ──
function verifyToken(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1]; // Bearer <token>

  if (!token)
    return res.status(401).json({ message: "Access denied. No token." });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // { user_id, role }
    next();
  } catch (err) {
    return res.status(403).json({ message: "Invalid or expired token." });
  }
}

// ── GET /api/profile ──
// Returns user info + role-specific profile
router.get("/", verifyToken, async (req, res) => {
  const { user_id, role } = req.user;

  try {
    const [userRows] = await pool.query(
      "SELECT user_id, first_name, last_name, email, cnic, gender, role, created_at FROM users WHERE user_id = ?",
      [user_id],
    );

    if (userRows.length === 0) {
      return res.status(404).json({ message: "User not found." });
    }

    const user = userRows[0];

    let profile = null;

    if (role === "teacher") {
      const [tp] = await pool.query(
        "SELECT * FROM teacher_profiles WHERE user_id = ?",
        [user_id],
      );
      profile = tp[0] || null;
    } else {
      const [sp] = await pool.query(
        "SELECT * FROM student_profiles WHERE user_id = ?",
        [user_id],
      );
      profile = sp[0] || null;
    }

    return res.status(200).json({ user, profile });
  } catch (err) {
    console.error("Get profile error:", err);
    return res.status(500).json({ message: "Server error." });
  }
});

// ── PUT /api/profile/teacher ──
// Update teacher profile (onboarding data)
router.put("/teacher", verifyToken, async (req, res) => {
  if (req.user.role !== "teacher") {
    return res
      .status(403)
      .json({ message: "Only teachers can update this profile." });
  }

  const {
    school_name,
    education,
    degree,
    description,
    experience_years,
    phone_number,
    profile_picture,
  } = req.body;

  try {
    await pool.query(
      `UPDATE teacher_profiles SET
        school_name = ?, education = ?, degree = ?,
        description = ?, experience_years = ?,
        phone_number = ?, profile_picture = ?
       WHERE user_id = ?`,
      [
        school_name,
        education,
        degree,
        description,
        experience_years,
        phone_number,
        profile_picture,
        req.user.user_id,
      ],
    );

    return res
      .status(200)
      .json({ message: "Teacher profile updated successfully." });
  } catch (err) {
    console.error("Update teacher profile error:", err);
    return res.status(500).json({ message: "Server error." });
  }
});

// ── PUT /api/profile/student ──
// Update student profile (onboarding data)
router.put("/student", verifyToken, async (req, res) => {
  if (req.user.role !== "student") {
    return res
      .status(403)
      .json({ message: "Only students can update this profile." });
  }

  const {
    roll_number,
    department,
    semester,
    institution_name,
    phone_number,
    profile_picture,
  } = req.body;

  try {
    await pool.query(
      `UPDATE student_profiles SET
        roll_number = ?, department = ?, semester = ?,
        institution_name = ?, phone_number = ?,
        profile_picture = ?
       WHERE user_id = ?`,
      [
        roll_number,
        department,
        semester,
        institution_name,
        phone_number,
        profile_picture,
        req.user.user_id,
      ],
    );

    return res
      .status(200)
      .json({ message: "Student profile updated successfully." });
  } catch (err) {
    console.error("Update student profile error:", err);
    return res.status(500).json({ message: "Server error." });
  }
});

module.exports = router;
