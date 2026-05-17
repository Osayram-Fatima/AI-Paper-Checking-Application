import 'package:flutter/material.dart';

class PaperUploadScreen extends StatefulWidget {
  const PaperUploadScreen({super.key});

  @override
  State<PaperUploadScreen> createState() => _PaperUploadScreenState();
}

class _PaperUploadScreenState extends State<PaperUploadScreen>
    with TickerProviderStateMixin {
  // ── Animations ──
  late AnimationController _glowController;
  late AnimationController _floatController;
  late Animation<double> _glowAnim;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _floatAnim = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E2A), // ← Same navy blue!
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E2A),
              Color(0xFF0D1540),
              Color(0xFF0A1035),
            ], // ← Same gradient!
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              24,
              size.height * 0.06,
              24,
              size.height * 0.18 + 80, // Extra padding for bottom nav
            ),
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 60),
                _buildMainCard(size),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  // ════════════════════════════ TOP BAR ════════════════════════════
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const Text(
            "Paper Upload",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5757),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════ MAIN CARD ════════════════════════════
  Widget _buildMainCard(Size size) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value * 0.3),
        child: child!,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A2570),
              Color(0xFF0F1A5A),
            ], // Same HomeScreen style
          ),
          border: Border.all(color: const Color(0xFF2A3580), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A6CF7).withOpacity(0.25),
              blurRadius: 40,
              spreadRadius: -5,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _glowAnim,
              builder: (context, child) => Transform.scale(
                scale: 1.0 + (_glowAnim.value * 0.05),
                child: child!,
              ),
              child: _buildIllustration(),
            ),
            const SizedBox(height: 44),
            const Text(
              "Upload Not Allowed",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Your teacher has not allowed paper upload for students.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFB0BAD3).withOpacity(0.85),
                fontSize: 15,
                height: 1.6,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════ ILLUSTRATION ════════════════════════════
  Widget _buildIllustration() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B6B).withOpacity(0.2),
            const Color(0xFFFF8E8E).withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFF6B6B).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.description_rounded, size: 60, color: Colors.white),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B6B).withOpacity(0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════ INFO CARD ════════════════════════════
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF131A4F).withOpacity(0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A3580), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A6CF7).withOpacity(0.1),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Contact your teacher to enable paper upload permission.",
              style: TextStyle(
                color: const Color(0xFFB0BAD3).withOpacity(0.85),
                fontSize: 13.5,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════ NAVBAR (Same as HomeScreen) ════════════════════════════
  Widget _buildNavBar() {
    const int selectedIndex = 3; // Paper tab selected
    const List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_rounded, 'label': "HOME"},
      {'icon': Icons.bar_chart_rounded, 'label': "RESULTS"},
      {'icon': Icons.menu_book_rounded, 'label': "SUBJECTS"},
      {'icon': Icons.description_rounded, 'label': "PAPER"},
      {'icon': Icons.person_rounded, 'label': "PROFILE"},
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(navItems.length, (i) {
          final isSelected = selectedIndex == i;
          return GestureDetector(
            onTap: () {}, // Add navigation logic here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Icon(
                  navItems[i]['icon'],
                  color: isSelected
                      ? const Color(0xFF1E3A8A)
                      : const Color(0xFF64748B),
                  size: 30,
                ),
                const SizedBox(height: 4),
                Text(
                  navItems[i]['label'],
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF1E3A8A)
                        : const Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
