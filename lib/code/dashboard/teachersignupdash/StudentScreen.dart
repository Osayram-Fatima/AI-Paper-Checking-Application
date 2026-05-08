import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

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
              child: CustomPaint(painter: _StudentPainter()),
            ),

            const SizedBox(height: 24),

            Text(
              'No Students Yet!',
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
              'Add students to your classes to manage them here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 32),

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

class _StudentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Main student (center, bigger) ──
    _drawPerson(canvas, w * 0.50, h * 0.38, 26, const Color(0xFF4C6EF5));

    // ── Left student ──
    _drawPerson(canvas, w * 0.24, h * 0.48, 20, const Color(0xFF7C3AED));

    // ── Right student ──
    _drawPerson(canvas, w * 0.76, h * 0.48, 20, const Color(0xFF7C3AED));

    // ── Plus badge (add) ──
    final badgePaint = Paint()
      ..color = const Color(0xFF9333EA)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.74, h * 0.22), 14, badgePaint);

    final plusPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.74, h * 0.15),
      Offset(w * 0.74, h * 0.29),
      plusPaint,
    );
    canvas.drawLine(
      Offset(w * 0.67, h * 0.22),
      Offset(w * 0.81, h * 0.22),
      plusPaint,
    );

    // ── Ground line ──
    final groundPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.10, h * 0.80),
      Offset(w * 0.90, h * 0.80),
      groundPaint,
    );

    // ── Book under main student ──
    final bookPaint = Paint()..color = const Color(0xFF3B5BDB);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.38, h * 0.72, w * 0.24, h * 0.08),
        const Radius.circular(4),
      ),
      bookPaint,
    );
    final pagePaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(w * 0.50, h * 0.72),
      Offset(w * 0.50, h * 0.80),
      pagePaint,
    );
  }

  void _drawPerson(Canvas canvas, double cx, double cy, double r, Color color) {
    final headPaint = Paint()..color = color;
    final bodyPaint = Paint()..color = color.withOpacity(0.75);

    // Head
    canvas.drawCircle(Offset(cx, cy - r * 0.6), r * 0.55, headPaint);

    // Body (rounded rect)
    final bodyPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - r * 0.65, cy, r * 1.3, r * 1.1),
          const Radius.circular(8),
        ),
      );
    canvas.drawPath(bodyPath, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
