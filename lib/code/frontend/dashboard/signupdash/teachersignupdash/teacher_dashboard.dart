// lib/code/frontend/screens/TeacherDashboard.dart
// ─────────────────────────────────────────────────────────────
//  Dynamic Teacher Dashboard with class management.
//  • Loads persisted class on startup.
//  • Top-bar class pill opens SelectClassScreen.
//  • Dashboard stats refresh automatically after class change.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_paper_checking/code/frontend/session/user_session.dart';
import 'package:ai_paper_checking/code/frontend/services/class_service.dart';
import 'package:ai_paper_checking/code/frontend/session/class_preferences.dart';
import 'package:ai_paper_checking/code/frontend/dashboard/signupdash/teachersignupdash/class_screen/select_class_screen.dart';

// ── Screens ──
import 'AttendanceScreen.dart';
import 'PaperScreen.dart';
import 'StudentScreen.dart';
import 'ProfileScreen.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;

  // ── Class state ──────────────────────────────────────────────
  ClassModel? _selectedClass;
  DashboardStats? _stats;
  bool _statsLoading = false;

  // ── Sizes & Spacing ──
  static const double topBarPaddingTop = 20;
  static const double topBarPaddingH = 24;
  static const double menuIconSize = 34;
  static const double bellIconSize = 34;
  static const double topBarToGreetingGap = 42;
  static const double greetingFontSize = 18;
  static const double nameFontSize = 28;
  static const double subtitleFontSize = 15;
  static const double dpSize = 110;
  static const double dpIconSize = 50;
  static const double greetingToCardGap = 34;
  static const double cardBorderRadius = 28;
  static const double navHeight = 90;
  static const double navIconSize = 32;
  static const double navCircleSize = 44;
  static const double navFontSize = 10;
  static const double navItemWidth = 70;

  final List<Map<String, dynamic>> _navItems = [
    {'label': 'HOME', 'icon': 'lib/assets/icons/nav/HOME.svg'},
    {'label': 'ATTENDENCE', 'icon': 'lib/assets/icons/nav/ATTENDENCE.svg'},
    {'label': 'PAPER', 'icon': 'lib/assets/icons/nav/PAPER.svg'},
    {'label': 'STUDENT', 'icon': 'lib/assets/icons/nav/STUDNET.svg'},
    {'label': 'PROFILE', 'icon': 'lib/assets/icons/nav/PROFILE.svg'},
  ];

  // ── Lifecycle ────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _restoreClass();
  }

  Future<void> _restoreClass() async {
    final cls = await ClassPreferences.loadSelectedClass();
    if (cls != null && mounted) {
      setState(() => _selectedClass = cls);
      _fetchStats(cls.classId);
    }
  }

  Future<void> _fetchStats(int classId) async {
    if (!mounted) return;
    setState(() => _statsLoading = true);
    try {
      final stats = await ClassService.fetchStats(classId);
      if (mounted)
        setState(() {
          _stats = stats;
          _statsLoading = false;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          _stats = DashboardStats.empty();
          _statsLoading = false;
        });
    }
  }

  Future<void> _openClassSelector() async {
    final result = await Navigator.push<ClassModel>(
      context,
      MaterialPageRoute(builder: (_) => const SelectClassScreen()),
    );
    if (result != null && mounted) {
      setState(() {
        _selectedClass = result;
        _stats = null;
      });
      _fetchStats(result.classId);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get _teacherName {
    final name = UserSession.firstName;
    return name.trim().isNotEmpty ? name : 'Teacher';
  }

  String get _salutation =>
      UserSession.gender.toLowerCase() == 'female' ? 'Mam' : 'Sir';

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E1B4B),
                  Color(0xFF312E81),
                ],
              ),
            ),
          ),

          // ── Soft glow circles ──
          Positioned(
            top: -80,
            right: -40,
            child: _glowCircle(220, Colors.purple, 0.18),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: _glowCircle(180, Colors.blue, 0.12),
          ),

          SafeArea(
            child: Column(
              children: [
                if (_selectedIndex == 0) _buildTopSection(),
                if (_selectedIndex == 0)
                  const SizedBox(height: greetingToCardGap),
                Expanded(
                  child: _selectedIndex == 0
                      ? _buildHomeBody()
                      : _buildNavScreen(),
                ),
                _buildBottomNav(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(double size, Color color, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(opacity),
    ),
  );

  // ── NAV SCREENS ───────────────────────────────────────────────
  Widget _buildNavScreen() {
    switch (_selectedIndex) {
      case 1:
        return const AttendanceScreen();
      case 2:
        return const PaperScreen();
      case 3:
        return const StudentScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox();
    }
  }

  // ── TOP SECTION ───────────────────────────────────────────────
  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        topBarPaddingH,
        topBarPaddingTop,
        topBarPaddingH,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top bar: menu | class pill | bell ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconBox(
                Image.asset(
                  'lib/assets/icons/menu_notification/menu.png',
                  width: menuIconSize,
                  height: menuIconSize,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: menuIconSize,
                  ),
                ),
              ),

              // ── Class pill ──
              GestureDetector(
                onTap: _openClassSelector,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedClass?.className ?? 'Select Class',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              _iconBox(
                Image.asset(
                  'lib/assets/icons/menu_notification/bell.png',
                  width: bellIconSize,
                  height: bellIconSize,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: bellIconSize,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: topBarToGreetingGap),

          // ── Greeting row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: greetingFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_salutation $_teacherName',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedClass != null
                          ? (_selectedClass!.subjectName != null
                                ? '${_selectedClass!.className}  ·  ${_selectedClass!.subjectName}'
                                : _selectedClass!.className)
                          : 'Manage your classes and students easily',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _profileAvatar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBox(Widget child) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
    ),
    child: child,
  );

  Widget _profileAvatar() => Container(
    width: dpSize,
    height: dpSize,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5)],
      ),
      border: Border.all(color: Colors.white.withOpacity(0.18), width: 2),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF7C3AED).withOpacity(0.35),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: const Icon(
      Icons.person_rounded,
      color: Colors.white,
      size: dpIconSize,
    ),
  );

  // ── HOME BODY ─────────────────────────────────────────────────

  Widget _buildHomeBody() {
    if (_selectedClass == null) return _buildNoClassCard();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          _buildStatsGrid(),
          const SizedBox(height: 18),
          _buildJoinCodeCard(),
        ],
      ),
    );
  }

  // ── Empty state ──────────────────────────────────────────────

  Widget _buildNoClassCard() => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    child: _glassCard(
      child: Column(
        children: [
          SvgPicture.asset(
            'lib/assets/icons/dashboard/class_vector.svg',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 18),
          Text(
            'No Classes Yet!',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Add your first class to start managing students, papers and attendance.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.75),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          _gradientButton(label: 'ADD CLASS', onTap: _openClassSelector),
        ],
      ),
    ),
  );

  // ── Stats grid ───────────────────────────────────────────────

  Widget _buildStatsGrid() {
    final s = _stats;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.3,
      children: [
        _statCard(
          icon: Icons.people_rounded,
          label: 'Students',
          value: _statsLoading ? '…' : '${s?.studentCount ?? 0}',
          color: const Color(0xFF6366F1),
        ),
        _statCard(
          icon: Icons.description_rounded,
          label: 'Papers',
          value: _statsLoading ? '…' : '${s?.paperCount ?? 0}',
          color: const Color(0xFF8B5CF6),
        ),
        _statCard(
          icon: Icons.how_to_reg_rounded,
          label: 'Present Today',
          value: _statsLoading
              ? '…'
              : s?.attendanceTaken == true
              ? '${s!.presentToday}'
              : '—',
          color: const Color(0xFF10B981),
        ),
        _statCard(
          icon: Icons.bar_chart_rounded,
          label: 'Avg Score',
          value: _statsLoading
              ? '…'
              : s?.avgScore != null
              ? '${s!.avgScore!.toStringAsFixed(1)}%'
              : '—',
          color: const Color(0xFFF59E0B),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) => _glassCard(
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // ── Join-code display card ────────────────────────────────────

  Widget _buildJoinCodeCard() {
    final cls = _selectedClass!;
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.vpn_key_rounded,
                color: Color(0xFFA5B4FC),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Class Join Code',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  cls.joinCode,
                  style: GoogleFonts.sourceCodePro(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 5,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Copy to clipboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Join code copied!',
                        style: GoogleFonts.poppins(),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    color: Color(0xFFA5B4FC),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Share this code with students to let them join the class.',
            style: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared glass card ────────────────────────────────────────

  Widget _glassCard({required Widget child, EdgeInsetsGeometry? padding}) =>
      Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.fromLTRB(22, 24, 22, 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      );

  Widget _gradientButton({
    required String label,
    required VoidCallback onTap,
  }) => Container(
    width: 210,
    height: 56,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6366F1).withOpacity(0.35),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.white.withOpacity(0.15),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // ── BOTTOM NAVIGATION ─────────────────────────────────────────

  Widget _buildBottomNav() => Container(
    height: navHeight,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(34),
        topRight: Radius.circular(34),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 25,
          offset: const Offset(0, -6),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(_navItems.length, (i) {
        final isSelected = _selectedIndex == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = i),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: navItemWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: navCircleSize,
                  height: navCircleSize,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEEF2FF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      _navItems[i]['icon'],
                      width: navIconSize,
                      height: navIconSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _navItems[i]['label'],
                  style: GoogleFonts.poppins(
                    fontSize: navFontSize,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF4F46E5)
                        : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  height: 3,
                  width: isSelected ? 36 : 0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
  );
}
