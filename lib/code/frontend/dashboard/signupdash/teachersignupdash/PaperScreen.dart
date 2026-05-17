import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaperScreen extends StatelessWidget {
  const PaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Illustration ──
            SizedBox(
              width: 160,
              height: 160,
              child: CustomPaint(painter: _PaperPainter()),
            ),

            const SizedBox(height: 24),

            Text(
              'No Papers Yet!',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Upload exam papers and let AI do the checking for you.',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 32),

            // Primary button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B5BDB), Color(0xFF9333EA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'ADD CLASS',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Back paper (shadow) ──
    final backPaint = Paint()..color = const Color(0xFF1E2D6B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.22, h * 0.18, w * 0.60, h * 0.72),
        const Radius.circular(10),
      ),
      backPaint,
    );

    // ── Middle paper ──
    final midPaint = Paint()..color = const Color(0xFF2A3F8F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.16, h * 0.13, w * 0.60, h * 0.72),
        const Radius.circular(10),
      ),
      midPaint,
    );

    // ── Front paper ──
    final frontPaint = Paint()..color = const Color(0xFF3B5BDB);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.08, w * 0.60, h * 0.72),
        const Radius.circular(10),
      ),
      frontPaint,
    );

    // ── Lines on front paper ──
    final linePaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 5; i++) {
      final y = h * 0.24 + i * h * 0.10;
      canvas.drawLine(Offset(w * 0.20, y), Offset(w * 0.60, y), linePaint);
    }

    // ── AI spark / star ──
    final sparkPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    void drawStar(double cx, double cy, double r) {
      final path = Path();
      for (int i = 0; i < 8; i++) {
        final angle = i * 3.14159 / 4;
        final radius = i.isEven ? r : r * 0.45;
        final x = cx + radius * _cos(angle);
        final y = cy + radius * _sin(angle);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, sparkPaint);
    }

    drawStar(w * 0.78, h * 0.22, 14);
    drawStar(w * 0.85, h * 0.42, 8);
    drawStar(w * 0.70, h * 0.38, 6);

    // ── Checkmark on paper ──
    final checkPaint = Paint()
      ..color = const Color(0xFF7CFFB2)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final checkPath = Path()
      ..moveTo(w * 0.20, h * 0.60)
      ..lineTo(w * 0.30, h * 0.70)
      ..lineTo(w * 0.50, h * 0.50);
    canvas.drawPath(checkPath, checkPaint);
  }

  double _cos(double a) => (a == 0)
      ? 1
      : (a == 1.5708)
      ? 0
      : (a == 3.14159)
      ? -1
      : (a == 4.71239)
      ? 0
      : _cosCalc(a);

  double _cosCalc(double a) {
    double result = 1, term = 1;
    for (int i = 1; i <= 10; i++) {
      term *= -a * a / (2 * i * (2 * i - 1));
      result += term;
    }
    return result;
  }

  double _sin(double a) {
    double result = a, term = a;
    for (int i = 1; i <= 10; i++) {
      term *= -a * a / ((2 * i + 1) * (2 * i));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
