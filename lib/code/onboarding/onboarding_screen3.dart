import 'package:flutter/material.dart';
import 'onboarding_config.dart';
import '../session/user_session.dart'; // ✅ ADDED
import '../dashboard/student_dashboard.dart'; // ✅ ADDED
import '../dashboard/teacher_dashboard.dart'; // ✅ ADDED

// ─────────────────────────────────────────────
//  SCREEN 3 — Secure & Reliable
//  Last screen → "Get Started" → Role-based Dashboard
// ─────────────────────────────────────────────

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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

  // ✅ UPDATED — Role check karke navigate karo
  void _getStarted(BuildContext context) {
    if (UserSession.role == 'teacher') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const TeacherDashboard()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const StudentDashboard()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: OnboardingConfig.bgColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Radial glow
            Positioned(
              top: size.height * 0.05,
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
                        OnboardingConfig.primaryBlue.withOpacity(0.3),
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
                    height: size.height * 0.42,
                    child: _SecureIllustration(),
                  ),

                  const SizedBox(height: 10),

                  // ── Title ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "Secure &\nReliable",
                      textAlign: TextAlign.center,
                      style: OnboardingConfig.titleStyle(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Subtitle ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Your data is safe with us. Access your information anytime, anywhere.",
                      textAlign: TextAlign.center,
                      style: OnboardingConfig.subtitleStyle(),
                    ),
                  ),

                  const Spacer(),

                  // ── Bottom — dots + Get Started button ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                    child: Column(
                      children: [
                        // Dots — page 3 active
                        _buildDots(2),

                        const SizedBox(height: 28),

                        // Get Started full-width button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: OnboardingConfig.buttonGradient,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: OnboardingConfig.primaryBlue
                                      .withOpacity(0.45),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => _getStarted(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                "Get Started",
                                style: OnboardingConfig.buttonStyle(),
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildDots(int activePage) {
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
            color: isActive
                ? OnboardingConfig.primaryBlue
                : Colors.white.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
//  Illustration — Shield with lock
// ─────────────────────────────────────────────

class _SecureIllustration extends StatelessWidget {
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
                  color: OnboardingConfig.primaryBlue.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
            ),

            // Inner ring
            Container(
              width: 175,
              height: 175,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: OnboardingConfig.primaryBlue.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
            ),

            // Shield
            Container(
              width: 100,
              height: 115,
              decoration: BoxDecoration(
                gradient: OnboardingConfig.shieldGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: OnboardingConfig.primaryBlue.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.lock_rounded, color: Colors.white, size: 42),
              ),
            ),

            // Green check badge
            Positioned(
              top: 30,
              right: 40,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: OnboardingConfig.successGreen,
                ),
                child: const Icon(
                  Icons.check_rounded,
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
