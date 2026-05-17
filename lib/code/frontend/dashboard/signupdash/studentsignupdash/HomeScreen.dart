import 'package:flutter/material.dart';
import 'package:ai_paper_checking/code/frontend/session/user_session.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // ── Animations ──
  late AnimationController _glowController;
  late AnimationController _floatController;
  late Animation<double> _glowAnim;
  late Animation<double> _floatAnim;

  // ── Nav ──
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_rounded, 'label': "HOME"},
    {'icon': Icons.bar_chart_rounded, 'label': "RESULTS"},
    {'icon': Icons.menu_book_rounded, 'label': "SUBJECTS"},
    {'icon': Icons.description_rounded, 'label': "PAPER"},
    {'icon': Icons.person_rounded, 'label': "PROFILE"},
  ];

  // ── User ──
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String get _userFullName {
    if (UserSession.firstName.isNotEmpty && UserSession.lastName.isNotEmpty) {
      return "${UserSession.firstName} ${UserSession.lastName}";
    } else if (UserSession.email.isNotEmpty) {
      return UserSession.email.split('@').first;
    }
    return "Student";
  }

  String get _userInitials {
    try {
      if (UserSession.firstName.isNotEmpty && UserSession.lastName.isNotEmpty) {
        return "${UserSession.firstName[0]}${UserSession.lastName[0]}"
            .toUpperCase();
      } else if (UserSession.email.isNotEmpty) {
        return UserSession.email.substring(0, 1).toUpperCase();
      }
    } catch (_) {}
    return "";
  }

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
      backgroundColor: const Color(0xFF0A0E2A),
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E2A), Color(0xFF0D1540), Color(0xFF0A1035)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 32),
                _buildWelcomeCard(size),
                const SizedBox(height: 28),
                _buildQuickStats(),
                const SizedBox(height: 28),
                _buildSectionTitle("Recent Activity"),
                const SizedBox(height: 14),
                _buildActivityList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  // ════════════════════════════
  // TOP BAR
  // ════════════════════════════
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      child: Column(
        children: [
          // Row 1: Menu | Bell
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
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

          const SizedBox(height: 40),

          // Row 2: Greeting + Name | Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting,
                    style: const TextStyle(
                      color: Color(0xFFB0BAD3),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _userFullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              _ProfileAvatar(initials: _userInitials),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════
  // WELCOME CARD
  // ════════════════════════════
  Widget _buildWelcomeCard(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _floatAnim,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _floatAnim.value * 0.3),
          child: child!,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A2570), Color(0xFF0F1A5A)],
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
                animation: _floatAnim,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _floatAnim.value),
                  child: child!,
                ),
                child: _HouseIllustration(glowAnim: _glowAnim),
              ),
              const SizedBox(height: 24),
              Text(
                "Welcome, ${_userFullName.split(' ').first}!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "This is your dashboard. Once your teacher adds classes, you will see your progress here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFB0BAD3).withOpacity(0.85),
                  fontSize: 13.5,
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B8BFF), Color(0xFF4A6CF7)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A6CF7).withOpacity(0.45),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 13,
                      ),
                      child: Text(
                        "Explore Dashboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════
  // QUICK STATS
  // ════════════════════════════
  Widget _buildQuickStats() {
    final stats = [
      {'icon': Icons.class_rounded, 'label': "CLASSES", 'value': "0"},
      {'icon': Icons.assignment_rounded, 'label': "PAPERS", 'value': "0"},
      {'icon': Icons.grade_rounded, 'label': "RESULTS", 'value': "—"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: stats
            .map(
              (stat) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _StatCard(data: stat),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ════════════════════════════
  // SECTION TITLE
  // ════════════════════════════
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const Text(
            "See All",
            style: TextStyle(
              color: Color(0xFF6B8BFF),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════
  // ACTIVITY LIST
  // ════════════════════════════
  Widget _buildActivityList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF131A4F).withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A3580), width: 1),
        ),
        child: Column(
          children: const [
            Icon(Icons.inbox_rounded, color: Colors.white, size: 44),
            SizedBox(height: 12),
            Text(
              "No recent activity yet",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════
  // NAVBAR
  // ════════════════════════════
  Widget _buildNavBar() {
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
        children: List.generate(_navItems.length, (i) {
          final isSelected = _selectedIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Icon(
                  _navItems[i]['icon'],
                  color: isSelected
                      ? const Color(0xFF1E3A8A)
                      : const Color(0xFF64748B),
                  size: 30,
                ),
                const SizedBox(height: 4),
                Text(
                  _navItems[i]['label'],
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

// ════════════════════════════════════════════
// WIDGETS
// ════════════════════════════════════════════

class _ProfileAvatar extends StatelessWidget {
  final String initials;
  const _ProfileAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    final bool hasInitials = initials.isNotEmpty;
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF6B8BFF), width: 2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A6CF7), Color(0xFF2A3ECC)],
        ),
      ),
      child: Center(
        child: hasInitials
            ? Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  letterSpacing: 1,
                ),
              )
            : const Icon(Icons.person_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF131A4F).withOpacity(0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A3580), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A6CF7).withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(data['icon'], color: Colors.white, size: 35),
          const SizedBox(height: 15),
          Text(
            data['value'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            data['label'],
            style: TextStyle(
              color: const Color(0xFFD8DADE).withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════
// HOUSE ILLUSTRATION
// ════════════════════════════════════════════

class _HouseIllustration extends StatelessWidget {
  final Animation<double> glowAnim;
  const _HouseIllustration({required this.glowAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnim,
      builder: (context, child) => Container(
        width: 180,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A6CF7).withOpacity(0.3 * glowAnim.value),
              blurRadius: 60,
              spreadRadius: 10,
            ),
          ],
        ),
        child: CustomPaint(
          painter: _HousePainter(glowIntensity: glowAnim.value),
          size: const Size(180, 160),
        ),
      ),
    );
  }
}

class _HousePainter extends CustomPainter {
  final double glowIntensity;
  _HousePainter({required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.drawCircle(
      Offset(cx, cy + 10),
      70,
      Paint()
        ..color = const Color(0xFF4A6CF7).withOpacity(0.15 * glowIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    canvas.drawPath(
      Path()..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - 45, cy - 10, 90, 70),
          const Radius.circular(6),
        ),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Color(0xFF5B6EF5), Color(0xFF3D52E0)],
        ).createShader(Rect.fromLTWH(cx - 45, cy - 10, 90, 70)),
    );

    canvas.drawPath(
      Path()
        ..moveTo(cx, cy - 50)
        ..lineTo(cx + 52, cy - 10)
        ..lineTo(cx - 52, cy - 10)
        ..close(),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF7B8EFF), Color(0xFF4A6CF7)],
        ).createShader(Rect.fromLTWH(cx - 52, cy - 50, 104, 44)),
    );

    canvas.drawRect(
      Rect.fromLTWH(cx + 14, cy - 58, 14, 22),
      Paint()..color = const Color(0xFF5B6EF5),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 14, cy + 18, 28, 42),
        const Radius.circular(14),
      ),
      Paint()..color = const Color(0xFF2A3580),
    );

    final winPaint = Paint()..color = const Color(0xFF8FA8FF).withOpacity(0.8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 38, cy + 5, 20, 18),
        const Radius.circular(4),
      ),
      winPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 18, cy + 5, 20, 18),
        const Radius.circular(4),
      ),
      winPaint,
    );

    _drawTree(canvas, Offset(cx - 62, cy + 55), 28, 44);
    _drawTree(canvas, Offset(cx + 62, cy + 55), 28, 44);

    canvas.drawLine(
      Offset(cx - 80, cy + 60),
      Offset(cx + 80, cy + 60),
      Paint()
        ..color = const Color(0xFF4A6CF7).withOpacity(0.25)
        ..strokeWidth = 1.5,
    );

    _drawStars(canvas, size);
  }

  void _drawTree(Canvas canvas, Offset base, double w, double h) {
    canvas.drawPath(
      Path()
        ..moveTo(base.dx, base.dy - h)
        ..lineTo(base.dx + w / 2, base.dy)
        ..lineTo(base.dx - w / 2, base.dy)
        ..close(),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF6B80F5), Color(0xFF3A4FD0)],
        ).createShader(Rect.fromLTWH(base.dx - w / 2, base.dy - h, w, h)),
    );
    canvas.drawRect(
      Rect.fromLTWH(base.dx - 4, base.dy, 8, 10),
      Paint()..color = const Color(0xFF3A4FD0),
    );
  }

  void _drawStars(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.5 * glowIntensity);
    for (final o in [
      Offset(size.width * 0.15, size.height * 0.12),
      Offset(size.width * 0.82, size.height * 0.10),
      Offset(size.width * 0.92, size.height * 0.30),
      Offset(size.width * 0.08, size.height * 0.35),
      Offset(size.width * 0.50, size.height * 0.05),
    ]) {
      canvas.drawCircle(o, 1.5, p);
    }
  }

  @override
  bool shouldRepaint(_HousePainter old) => old.glowIntensity != glowIntensity;
}
