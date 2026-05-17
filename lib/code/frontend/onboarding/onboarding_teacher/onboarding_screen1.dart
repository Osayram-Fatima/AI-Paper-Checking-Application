import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onboarding_config.dart';
import 'onboarding_screen2.dart';

// ─────────────────────────────────────────────
//  SCREEN 1 — Welcome to Check-In
//  Next → OnboardingScreen2
// ─────────────────────────────────────────────

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
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
        pageBuilder: (_, __, ___) => const OnboardingScreen2(),
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
                    child: _WelcomeIllustration(),
                  ),

                  const SizedBox(height: 10),

                  // ── Title ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Welcome to \nCheck-In",
                      textAlign: TextAlign.center,
                      style: OnboardingConfig.titleStyle(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Subtitle ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Smart attendance, paper management and classroom control in one place.",
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

                        // Dots — page 1 active
                        _buildDots(0),

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
//  Illustration — Clipboard with check
// ─────────────────────────────────────────────

class _WelcomeIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
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

            // Clipboard card
            Container(
              width: 150,
              height: 185,
              decoration: BoxDecoration(
                color: OnboardingConfig.cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: OnboardingConfig.primaryBlue.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_turned_in_rounded,
                    color: OnboardingConfig.primaryBlue,
                    size: 48,
                  ),
                  const SizedBox(height: 14),
                  ...[0.7, 0.5, 0.65].map(
                    (w) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 20,
                      ),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(w * 0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Green check badge
            Positioned(
              top: 28,
              right: 28,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: OnboardingConfig.successGreen,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
