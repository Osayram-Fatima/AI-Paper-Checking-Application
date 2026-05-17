import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'StudentOnboardingScreen2.dart';

// ─────────────────────────────────────────────
//  STUDENT ONBOARDING — Screen 1
//  "Smart Learning Assistant"
// ─────────────────────────────────────────────

class StudentOnboardingScreen1 extends StatefulWidget {
  const StudentOnboardingScreen1({super.key});

  @override
  State<StudentOnboardingScreen1> createState() =>
      _StudentOnboardingScreen1State();
}

class _StudentOnboardingScreen1State extends State<StudentOnboardingScreen1>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // ── Colors (student ke liye purple/teal theme) ──
  static const Color bgColor = Color(0xFF0D0F1A);
  static const Color primaryColor = Color(0xFF7C3AED); // purple
  static const Color accentColor = Color(0xFF06B6D4); // cyan

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Glow blob
            Positioned(
              top: size.height * 0.04,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 340,
                  height: 340,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        primaryColor.withOpacity(0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.07),

                  // ── Illustration ──
                  SizedBox(
                    height: size.height * 0.40,
                    child: _BookIllustration(
                      primaryColor: primaryColor,
                      accentColor: accentColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Title ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "Smart Learning\nAssistant",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Subtitle ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Get instant AI feedback on your papers and improve your writing skills faster than ever.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.65),
                        height: 1.6,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ── Dots + Next button ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                    child: Column(
                      children: [
                        _buildDots(0, primaryColor),
                        const SizedBox(height: 28),
                        _nextButton(context, primaryColor, accentColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextButton(BuildContext context, Color primary, Color accent) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, accent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StudentOnboardingScreen2()),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            "Next",
            style: GoogleFonts.raleway(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDots(int activePage, Color activeColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isActive = index == activePage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive ? activeColor : Colors.white.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}

// ── Book + AI Illustration ──
class _BookIllustration extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  const _BookIllustration({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
            ),
            // Inner ring
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
            ),
            // Book icon card
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
            // Star badge
            Positioned(
              top: 28,
              right: 38,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
