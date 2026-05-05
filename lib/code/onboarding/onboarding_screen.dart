import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      illustration: _IllustrationType.welcome,
      title: "Welcome to\nCheck-In",
      subtitle:
          "Smart attendance, paper management and classroom control in one place.",
    ),
    _OnboardingData(
      illustration: _IllustrationType.manage,
      title: "Manage Classes\nEffortlessly",
      subtitle:
          "Take attendance, upload papers and track student performance easily.",
    ),
    _OnboardingData(
      illustration: _IllustrationType.secure,
      title: "Secure &\nReliable",
      subtitle:
          "Your data is safe with us. Access your information anytime, anywhere.",
    ),
  ];

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
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    _fadeController.reset();
    _fadeController.forward();
    setState(() => _currentPage = index);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    // TODO: Replace with your TeacherLogin route
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const TeacherLogin()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1437),
      body: Stack(
        children: [
          // Subtle radial glow behind illustration
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
                      const Color(0xFF2B4FD8).withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          Column(
            children: [
              // PageView for illustrations + text
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPage(
                      data: _pages[index],
                      fadeAnimation: _fadeAnimation,
                      size: size,
                    );
                  },
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                child: _currentPage == _pages.length - 1
                    ? _buildGetStartedButton()
                    : _buildBottomControls(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Last page — full "Get Started" button
  Widget _buildGetStartedButton() {
    return Column(
      children: [
        _buildDots(),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B5BFA), Color(0xFF6B48FF)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B5BFA).withOpacity(0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _goToLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Get Started",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Pages 1 & 2 — Skip + dots + arrow button
  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Skip
        TextButton(
          onPressed: _goToLogin,
          child: Text(
            "Skip",
            style: GoogleFonts.raleway(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Dots
        _buildDots(),

        // Arrow button
        GestureDetector(
          onTap: _nextPage,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF3B5BFA), Color(0xFF6B48FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B5BFA).withOpacity(0.5),
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
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_pages.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? const Color(0xFF3B5BFA)
                : Colors.white.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// Single onboarding page widget
// ─────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final Animation<double> fadeAnimation;
  final Size size;

  const _OnboardingPage({
    required this.data,
    required this.fadeAnimation,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.08),

          // Illustration area
          SizedBox(
            height: size.height * 0.42,
            child: _OnboardingIllustration(type: data.illustration),
          ),

          const SizedBox(height: 40),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                color: Colors.white60,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Custom illustrations using Flutter drawing
// ─────────────────────────────────────────────

enum _IllustrationType { welcome, manage, secure }

class _OnboardingIllustration extends StatelessWidget {
  final _IllustrationType type;
  const _OnboardingIllustration({required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _IllustrationType.welcome:
        return _WelcomeIllustration();
      case _IllustrationType.manage:
        return _ManageIllustration();
      case _IllustrationType.secure:
        return _SecureIllustration();
    }
  }
}

// Screen 1 — Clipboard / attendance check
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
                  color: const Color(0xFF3B5BFA).withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
            // Inner card
            Container(
              width: 150,
              height: 185,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2B6D),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B5BFA).withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.assignment_turned_in_rounded,
                    color: Color(0xFF3B5BFA),
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
            // Checkmark badge
            Positioned(
              top: 28,
              right: 28,
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF22C55E),
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

// Screen 2 — Laptop / class management
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
            // Glow
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF3B5BFA).withOpacity(0.2),
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
                  color: const Color(0xFF1A2B6D),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            // Laptop screen
            Container(
              width: 155,
              height: 105,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2B6D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF3B5BFA).withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B5BFA).withOpacity(0.25),
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
                      const Icon(
                        Icons.bar_chart_rounded,
                        color: Color(0xFF3B5BFA),
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
            // Floating upload badge
            Positioned(
              top: 30,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B5BFA),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B5BFA).withOpacity(0.5),
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

// Screen 3 — Shield / security
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
            // Outer rings
            Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF3B5BFA).withOpacity(0.15),
                  width: 1.5,
                ),
              ),
            ),
            Container(
              width: 175,
              height: 175,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF3B5BFA).withOpacity(0.25),
                  width: 1.5,
                ),
              ),
            ),
            // Shield
            Container(
              width: 100,
              height: 115,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B5BFA), Color(0xFF1A2B6D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B5BFA).withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.lock_rounded, color: Colors.white, size: 42),
              ),
            ),
            // Check badge
            Positioned(
              top: 30,
              right: 40,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF22C55E),
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

// ─────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────

class _OnboardingData {
  final _IllustrationType illustration;
  final String title;
  final String subtitle;

  const _OnboardingData({
    required this.illustration,
    required this.title,
    required this.subtitle,
  });
}
