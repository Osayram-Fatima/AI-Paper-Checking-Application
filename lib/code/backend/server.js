require("dotenv").config();
const express = require("express");
const cors = require("cors");

const authRoutes = require("./database/routes/auth");
const profileRoutes = require("./database/routes/profile");
const classRoutes = require("./database/routes/classRoutes");

const app = express();

// ── Middleware ──
app.use(cors());
app.use(express.json());

// ── Routes ──
app.use("/api/auth", authRoutes);
app.use("/api/profile", profileRoutes);
app.use("/api/classes", classRoutes);

// ── Health check ──
app.get("/", (req, res) => {
  res.json({ message: "AI Paper Checking API is running ✅" });
});

// ── Start Server ──
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
