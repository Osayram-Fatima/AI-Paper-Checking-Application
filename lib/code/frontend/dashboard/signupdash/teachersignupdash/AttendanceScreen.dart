import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Illustration ──
            _buildIllustration(),

            const SizedBox(height: 24),

            Text(
              'No Attendance Yet!',
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
              'Mark today\'s attendance or add a class first to get started.',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 32),

            // Primary button — Mark Attendance
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

            // Secondary — Add Class (smaller)
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    // Clipboard / attendance illustration
    return SizedBox(
      width: 160,
      height: 160,
      child: CustomPaint(painter: _AttendancePainter()),
    );
  }
}

class _AttendancePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Clipboard body ──
    final bodyPaint = Paint()..color = const Color(0xFF2A4AB5);
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.14, w * 0.76, h * 0.78),
      const Radius.circular(14),
    );
    canvas.drawRRect(bodyRRect, bodyPaint);

    // ── Clip top bar ──
    final clipPaint = Paint()..color = const Color(0xFF9333EA);
    final clipRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.35, h * 0.06, w * 0.30, h * 0.14),
      const Radius.circular(8),
    );
    canvas.drawRRect(clipRRect, clipPaint);

    // ── Lines (rows) ──
    final linePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final y = h * 0.38 + i * h * 0.12;
      canvas.drawLine(Offset(w * 0.25, y), Offset(w * 0.75, y), linePaint);
    }

    // ── Check marks ──
    final checkPaint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    void drawCheck(double cx, double cy, double s) {
      final path = Path()
        ..moveTo(cx - s * 0.5, cy)
        ..lineTo(cx - s * 0.1, cy + s * 0.4)
        ..lineTo(cx + s * 0.5, cy - s * 0.4);
      canvas.drawPath(path, checkPaint);
    }

    drawCheck(w * 0.32, h * 0.38, 10);
    drawCheck(w * 0.32, h * 0.50, 10);
    drawCheck(w * 0.32, h * 0.62, 10);

    // ── X mark (absent) ──
    final xPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = w * 0.32;
    final cy = h * 0.74;
    const s = 5.0;
    canvas.drawLine(Offset(cx - s, cy - s), Offset(cx + s, cy + s), xPaint);
    canvas.drawLine(Offset(cx + s, cy - s), Offset(cx - s, cy + s), xPaint);

    // ── Pencil ──
    final pencilBody = Paint()..color = const Color(0xFFFFCC00);
    final pencilPath = Path()
      ..moveTo(w * 0.72, h * 0.28)
      ..lineTo(w * 0.85, h * 0.18)
      ..lineTo(w * 0.90, h * 0.24)
      ..lineTo(w * 0.77, h * 0.34)
      ..close();
    canvas.drawPath(pencilPath, pencilBody);

    final tipPaint = Paint()..color = const Color(0xFFFF8A65);
    final tipPath = Path()
      ..moveTo(w * 0.72, h * 0.28)
      ..lineTo(w * 0.68, h * 0.38)
      ..lineTo(w * 0.77, h * 0.34)
      ..close();
    canvas.drawPath(tipPath, tipPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
