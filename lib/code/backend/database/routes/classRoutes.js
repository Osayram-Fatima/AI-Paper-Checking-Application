// ============================================================
//  routes/classRoutes.js
//  Place at: database/routes/classRoutes.js
// ============================================================

const express = require("express");
const router = express.Router();
const pool = require("../db/connection"); // same as auth.js
const jwt = require("jsonwebtoken"); // same as auth.js — no separate middleware file needed

// ── Inline JWT auth (matches your auth.js pattern exactly) ───
function auth(req, res, next) {
  const authHeader =
    req.headers["authorization"] || req.headers["Authorization"];
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res
      .status(401)
      .json({ success: false, message: "No token provided." });
  }
  const token = authHeader.split(" ")[1];
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // { user_id, role }
    next();
  } catch (err) {
    return res
      .status(401)
      .json({ success: false, message: "Invalid or expired token." });
  }
}

// ── Utility: generate random 8-char join code ────────────────
function generateJoinCode(length = 8) {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  let code = "";
  for (let i = 0; i < length; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
}

async function uniqueJoinCode() {
  let code, exists;
  do {
    code = generateJoinCode();
    const [rows] = await pool.query(
      "SELECT class_id FROM classes WHERE join_code = ?",
      [code],
    );
    exists = rows.length > 0;
  } while (exists);
  return code;
}

// ════════════════════════════════════════════════════════════
//  POST /api/classes/create
//  Body: { class_name, subject_name? }
// ════════════════════════════════════════════════════════════
router.post("/create", auth, async (req, res) => {
  try {
    const teacherId = req.user.user_id;
    const { class_name, subject_name } = req.body;

    if (!class_name || !class_name.trim()) {
      return res
        .status(400)
        .json({ success: false, message: "class_name is required" });
    }

    const join_code = await uniqueJoinCode();

    const [result] = await pool.query(
      `INSERT INTO classes (teacher_id, class_name, subject_name, join_code)
       VALUES (?, ?, ?, ?)`,
      [teacherId, class_name.trim(), subject_name?.trim() || null, join_code],
    );

    const [rows] = await pool.query(
      "SELECT * FROM classes WHERE class_id = ?",
      [result.insertId],
    );

    return res.status(201).json({
      success: true,
      message: "Class created successfully",
      class: rows[0],
    });
  } catch (err) {
    console.error("[createClass]", err);
    return res.status(500).json({ success: false, message: "Server error" });
  }
});

// ════════════════════════════════════════════════════════════
//  GET /api/classes/my-classes
// ════════════════════════════════════════════════════════════
router.get("/my-classes", auth, async (req, res) => {
  try {
    const teacherId = req.user.user_id;

    const [classes] = await pool.query(
      `SELECT
         c.class_id,
         c.class_name,
         c.subject_name,
         c.join_code,
         c.created_at,
         COUNT(DISTINCT cs.student_id) AS student_count
       FROM classes c
       LEFT JOIN class_students cs ON cs.class_id = c.class_id
       WHERE c.teacher_id = ?
       GROUP BY c.class_id
       ORDER BY c.created_at DESC`,
      [teacherId],
    );

    return res.json({ success: true, classes });
  } catch (err) {
    console.error("[myClasses]", err);
    return res.status(500).json({ success: false, message: "Server error" });
  }
});

// ════════════════════════════════════════════════════════════
//  GET /api/classes/:classId/stats
// ════════════════════════════════════════════════════════════
router.get("/:classId/stats", auth, async (req, res) => {
  try {
    const teacherId = req.user.user_id;
    const { classId } = req.params;

    const [owned] = await pool.query(
      "SELECT class_id FROM classes WHERE class_id = ? AND teacher_id = ?",
      [classId, teacherId],
    );
    if (!owned.length) {
      return res.status(403).json({ success: false, message: "Access denied" });
    }

    const [[{ student_count }]] = await pool.query(
      "SELECT COUNT(*) AS student_count FROM class_students WHERE class_id = ?",
      [classId],
    );

    const [[{ paper_count }]] = await pool.query(
      "SELECT COUNT(*) AS paper_count FROM papers WHERE class_id = ?",
      [classId],
    );

    const today = new Date().toISOString().slice(0, 10);
    const [[attRow]] = await pool.query(
      `SELECT
         SUM(status = 'present') AS present_today,
         SUM(status = 'absent')  AS absent_today,
         COUNT(*)                AS total_today
       FROM attendance
       WHERE class_id = ? AND date = ?`,
      [classId, today],
    );

    const [[resultRow]] = await pool.query(
      `SELECT
         ROUND(AVG(r.marks_obtained / p.total_marks * 100), 1) AS avg_score
       FROM results r
       JOIN papers p ON p.paper_id = r.paper_id
       WHERE p.class_id = ? AND r.marks_obtained IS NOT NULL`,
      [classId],
    );

    return res.json({
      success: true,
      stats: {
        student_count: parseInt(student_count) || 0,
        paper_count: parseInt(paper_count) || 0,
        present_today: parseInt(attRow.present_today) || 0,
        absent_today: parseInt(attRow.absent_today) || 0,
        attendance_taken: parseInt(attRow.total_today) > 0,
        avg_score: parseFloat(resultRow.avg_score) || null,
      },
    });
  } catch (err) {
    console.error("[classStats]", err);
    return res.status(500).json({ success: false, message: "Server error" });
  }
});

// ════════════════════════════════════════════════════════════
//  GET /api/classes/:classId/students
// ════════════════════════════════════════════════════════════
router.get("/:classId/students", auth, async (req, res) => {
  try {
    const teacherId = req.user.user_id;
    const { classId } = req.params;

    const [owned] = await pool.query(
      "SELECT class_id FROM classes WHERE class_id = ? AND teacher_id = ?",
      [classId, teacherId],
    );
    if (!owned.length) {
      return res.status(403).json({ success: false, message: "Access denied" });
    }

    const [students] = await pool.query(
      `SELECT
         u.user_id,
         u.email,
         sp.first_name,
         sp.last_name,
         sp.roll_number,
         cs.joined_at
       FROM class_students cs
       JOIN users            u  ON u.user_id  = cs.student_id
       JOIN student_profiles sp ON sp.user_id = cs.student_id
       WHERE cs.class_id = ?
       ORDER BY sp.first_name ASC`,
      [classId],
    );

    return res.json({ success: true, students });
  } catch (err) {
    console.error("[classStudents]", err);
    return res.status(500).json({ success: false, message: "Server error" });
  }
});

// ════════════════════════════════════════════════════════════
//  POST /api/classes/join   (student joins via code)
// ════════════════════════════════════════════════════════════
router.post("/join", auth, async (req, res) => {
  try {
    const studentId = req.user.user_id;
    const { join_code } = req.body;

    if (!join_code) {
      return res
        .status(400)
        .json({ success: false, message: "join_code is required" });
    }

    const [classes] = await pool.query(
      "SELECT * FROM classes WHERE join_code = ?",
      [join_code.toUpperCase().trim()],
    );

    if (!classes.length) {
      return res
        .status(404)
        .json({ success: false, message: "Invalid join code" });
    }

    const cls = classes[0];

    const [already] = await pool.query(
      "SELECT id FROM class_students WHERE class_id = ? AND student_id = ?",
      [cls.class_id, studentId],
    );
    if (already.length) {
      return res
        .status(409)
        .json({ success: false, message: "Already enrolled in this class" });
    }

    await pool.query(
      "INSERT INTO class_students (class_id, student_id) VALUES (?, ?)",
      [cls.class_id, studentId],
    );

    return res.status(201).json({
      success: true,
      message: "Joined class successfully",
      class: {
        class_id: cls.class_id,
        class_name: cls.class_name,
        subject_name: cls.subject_name,
        join_code: cls.join_code,
      },
    });
  } catch (err) {
    console.error("[joinClass]", err);
    return res.status(500).json({ success: false, message: "Server error" });
  }
});

// ════════════════════════════════════════════════════════════
//  DELETE /api/classes/:classId
// ════════════════════════════════════════════════════════════
router.delete("/:classId", auth, async (req, res) => {
  try {
    const teacherId = req.user.user_id;
    const { classId } = req.params;

    const [result] = await pool.query(
      "DELETE FROM classes WHERE class_id = ? AND teacher_id = ?",
      [classId, teacherId],
    );

    if (!result.affectedRows) {
      return res
        .status(404)
        .json({ success: false, message: "Class not found or access denied" });
    }

    return res.json({ success: true, message: "Class deleted" });
  } catch (err) {
    console.error("[deleteClass]", err);
    return res.status(500).json({ success: false, message: "Server error" });
  }
});

module.exports = router;
