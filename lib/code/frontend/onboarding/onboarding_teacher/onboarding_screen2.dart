import 'package:flutter/material.dart';
import 'onboarding_config.dart';
import 'onboarding_screen3.dart';

// ─────────────────────────────────────────────
//  SCREEN 2 — Manage Classes Effortlessly
//  Next → OnboardingScreen3
// ─────────────────────────────────────────────

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2>
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

  void _skip(BuildContext context) {
    // TODO: Skip directly to TeacherLogin
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const TeacherLogin()),
    // );
  }

  void _next(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingScreen3(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
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
                    child: _ManageIllustration(),
                  ),

                  const SizedBox(height: 10),

                  // ── Title ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "Manage Classes\nEffortlessly",
                      textAlign: TextAlign.center,
                      style: OnboardingConfig.titleStyle(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Subtitle ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Take attendance, upload papers and track student performance easily.",
                      textAlign: TextAlign.center,
                      style: OnboardingConfig.subtitleStyle(),
                    ),
                  ),

                  const Spacer(),

                  // ── Bottom controls ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip
                        TextButton(
                          onPressed: () => _skip(context),
                          child: Text(
                            "Skip",
                            style: OnboardingConfig.skipStyle(),
                          ),
                        ),

                        // Dots — page 2 active
                        _buildDots(1),

                        // Arrow
                        _buildArrowButton(context),
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

  Widget _buildArrowButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _next(context),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: OnboardingConfig.buttonGradient,
          boxShadow: [
            BoxShadow(
              color: OnboardingConfig.primaryBlue.withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Illustration — Laptop with chart
// ─────────────────────────────────────────────

class _ManageIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 280,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: OnboardingConfig.primaryBlue.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),

            // Laptop base
            Positioned(
              bottom: 40,
              child: Container(
                width: 180,
                height: 12,
                decoration: BoxDecoration(
                  color: OnboardingConfig.cardColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            // Laptop screen
            Container(
              width: 155,
              height: 105,
              decoration: BoxDecoration(
                color: OnboardingConfig.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: OnboardingConfig.primaryBlue.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: OnboardingConfig.primaryBlue.withOpacity(0.25),
                    blurRadius: 24,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        color: OnboardingConfig.primaryBlue,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 7,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...[0.8, 0.55, 0.7].map(
                    (w) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        height: 6,
                        width: 120 * w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Upload badge
            Positioned(
              top: 30,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: OnboardingConfig.primaryBlue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: OnboardingConfig.primaryBlue.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
