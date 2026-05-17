import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_paper_checking/code/frontend/session/user_session.dart';

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

  static const double cardPaddingH = 22;
  static const double cardPaddingV = 30;
  static const double cardBorderRadius = 28;

  static const double folderSize = 160;

  static const double noClassFontSize = 30;
  static const double descFontSize = 16;

  static const double buttonHeight = 56;
  static const double buttonRadius = 30;
  static const double buttonFontSize = 16;
  static const double buttonWidth = 210;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Premium Gradient Background ──
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

          // ── Soft Glow ──
          Positioned(
            top: -80,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.18),
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            left: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.12),
              ),
            ),
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

  // ── Navigation Screens ──
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

  // ── TOP SECTION ──
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
          // ── Top Bar ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(
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

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(
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

          // ── Greeting Row ──
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
                      '${UserSession.gender.toLowerCase() == 'female' ? 'Mam' : 'Sir'} $_teacherName',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Manage your classes and students easily',
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

              // ── Profile Avatar ──
              Container(
                width: dpSize,
                height: dpSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5)],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: dpIconSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── HOME BODY ──
  Widget _buildHomeBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              cardPaddingH,
              cardPaddingV,
              cardPaddingH,
              cardPaddingV,
            ),
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
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  'lib/assets/icons/dashboard/class_vector.svg',
                  width: folderSize,
                  height: folderSize,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 18),

                Text(
                  'No Classes Yet!',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: noClassFontSize,
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
                    fontSize: descFontSize,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 36),

                // ── Add Button ──
                Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(buttonRadius),
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
                      borderRadius: BorderRadius.circular(buttonRadius),
                      splashColor: Colors.white.withOpacity(0.15),
                      highlightColor: Colors.white.withOpacity(0.08),
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 22,
                          ),

                          const SizedBox(width: 8),

                          Text(
                            'ADD CLASS',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
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

  // ── BOTTOM NAVIGATION ──
  Widget _buildBottomNav() {
    return Container(
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
        children: List.generate(_navItems.length, (index) {
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
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
                        _navItems[index]['icon'],
                        width: navIconSize,
                        height: navIconSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _navItems[index]['label'],
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
}
