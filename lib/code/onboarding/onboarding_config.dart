import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════
//  ONBOARDING CONFIG — yahan se font aur colors change karo
// ═══════════════════════════════════════════════════════════

class OnboardingConfig {
  // ── FONTS ──────────────────────────────────────────────
  // Sirf yahan font name change karo, poori app mein apply ho jaega
  // Google Fonts list: https://fonts.google.com
  //
  // Examples:
  //   GoogleFonts.raleway(...)
  //   GoogleFonts.poppins(...)
  //   GoogleFonts.lato(...)
  //   GoogleFonts.nunito(...)
  //   GoogleFonts.montserrat(...)

  static TextStyle titleStyle({
    double fontSize = 35,
    FontWeight fontWeight = FontWeight.w800,
    Color color = Colors.white,
    double height = 1.25,
  }) => GoogleFonts.raleway(
    // ← TITLE FONT YAHAN CHANGE KARO
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );

  static TextStyle subtitleStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = const Color.fromARGB(255, 255, 255, 255),
    double height = 1.6,
  }) => GoogleFonts.raleway(
    // ← SUBTITLE FONT YAHAN CHANGE KARO
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );

  static TextStyle buttonStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    Color color = Colors.white,
    double letterSpacing = 1.2,
  }) => GoogleFonts.raleway(
    // ← BUTTON FONT YAHAN CHANGE KARO
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
  );

  static TextStyle skipStyle() => GoogleFonts.raleway(
    // ← SKIP FONT YAHAN CHANGE KARO
    color: Colors.white54,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // ── COLORS ─────────────────────────────────────────────
  static const Color bgColor = Color(0xFF0B1437); // background
  static const Color primaryBlue = Color(0xFF3B5BFA); // buttons, dots
  static const Color accentPurple = Color(0xFF6B48FF); // gradient end
  static const Color cardColor = Color(0xFF1A2B6D); // illustration cards
  static const Color successGreen = Color(0xFF22C55E); // checkmark badges

  // ── GRADIENTS ──────────────────────────────────────────
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryBlue, accentPurple],
  );

  static const LinearGradient shieldGradient = LinearGradient(
    colors: [primaryBlue, cardColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
