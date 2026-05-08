import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_paper_checking/code/session/user_session.dart';

// ── Alag screens import karo ──
import '../teachersignupdash/AttendanceScreen.dart';
import '../teachersignupdash/PaperScreen.dart';
import '../teachersignupdash/StudentScreen.dart';
import '../teachersignupdash/ProfileScreen.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;

  // ════════════════════════════════════════════
  // 🎛️  POSITION & SIZE CONTROLS — edit karo
  // ════════════════════════════════════════════

  // ── Top Bar ──
  static const double topBarPaddingTop = 20;
  static const double topBarPaddingH = 24;

  // ── Menu Icon ──
  static const double menuIconSize = 35;

  // ── Bell Icon ──
  static const double bellIconSize = 35;

  // ── CLASS pill ──
  static const double classPillPaddingH = 18;
  static const double classPillPaddingV = 8;
  static const double classFontSize = 14;

  // ── Gap between topbar and greeting ──
  static const double topBarToGreetingGap = 46;

  // ── Greeting text ──
  static const double greetingFontSize = 18;
  static const double nameFontSize = 27;
  static const double subtitleFontSize = 17;

  // ── DP (profile circle) ──
  static const double dpSize = 125;
  static const double dpBorderWidth = 2;
  static const double dpIconSize = 48;
  static const double dpGapFromText = 0;
  static const double dpTopOffset = -20;
  static const double dpBottomOffset = 15;
  static const double dpLeftOffset = 10;
  static const double dpRightOffset = 2;

  // ── Gap between greeting section and card ──
  static const double greetingToCardGap = 45;

  // ── Card ──
  static const double cardPaddingH = 20;
  static const double cardPaddingV = 30;
  static const double cardBorderRadius = 22;
  static const double cardBorderWidth = 3;

  // ── SVG illustration ──
  static const double folderSize = 160;

  // ── Gap between folder/SVG and text ──
  static const double folderToTextGap = 14;

  // ── "No Classes Yet!" text ──
  static const double noClassFontSize = 30;

  // ── Description text ──
  static const double descFontSize = 18;

  // ── Gap before button ──
  static const double textToButtonGap = 36;

  // ── Add Class Button ──
  static const double buttonHeight = 54;
  static const double buttonRadius = 32;
  static const double buttonFontSize = 18;
  static const double buttonWidth = 210;
  static const double buttonBorderWidth = 1.8; // ← border thickness control

  // ── Bottom Nav ──
  static const double navHeight = 90;
  static const double navIconSize = 40;
  static const double navCircleSize = 42;
  static const double navFontSize = 10;
  static const double navItemWidth = 69;

  // ════════════════════════════════════════════

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
    final full = '$name'.trim();
    return full.isNotEmpty ? full : 'Teacher';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── SVG Background ──
          Positioned.fill(
            child: SvgPicture.asset(
              'lib/assets/dashboardbg/bg.svg',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                if (_selectedIndex == 0) _buildTopSection(),
                if (_selectedIndex == 0) SizedBox(height: greetingToCardGap),
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

  // ── Route karo tabs 1-4 ──
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
      padding: EdgeInsets.fromLTRB(
        topBarPaddingH,
        topBarPaddingTop,
        topBarPaddingH,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
            ],
          ),

          SizedBox(height: topBarToGreetingGap),

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
                        color: Colors.white,
                        fontSize: greetingFontSize,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mam $_teacherName',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Here is what happening today',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: dpGapFromText),

              Transform.translate(
                offset: Offset(
                  dpLeftOffset - dpRightOffset,
                  dpTopOffset + dpBottomOffset,
                ),
                child: Container(
                  width: dpSize,
                  height: dpSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E2D6B),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: dpBorderWidth,
                    ),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: const Color.fromARGB(217, 255, 255, 255),
                    size: dpIconSize,
                  ),
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
            padding: EdgeInsets.all(cardBorderWidth),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                cardPaddingH,
                cardPaddingV,
                cardPaddingH,
                cardPaddingV,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(cardBorderRadius - 2),
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'lib/assets/icons/add_class/addclass.svg',
                    width: folderSize,
                    height: folderSize,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: folderToTextGap),

                  Text(
                    'No Classes Yet!',
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: noClassFontSize,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Add your first class to start managing students, papers and attendance.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: descFontSize,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: textToButtonGap),

                  // ✅ Outlined button — transparent bg, white border
                  Container(
                    width: buttonWidth,
                    height: buttonHeight,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(buttonRadius),
                      border: Border.all(
                        color: Colors.white,
                        width: buttonBorderWidth,
                      ),
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
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ──
  Widget _buildBottomNav() {
    return Container(
      height: navHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
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
                    duration: const Duration(milliseconds: 200),
                    width: navCircleSize,
                    height: navCircleSize,
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
                    style: GoogleFonts.raleway(
                      fontSize: navFontSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4338CA),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: 3,
                    width: isSelected ? 40 : 0,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
                            )
                          : null,
                      color: isSelected ? null : Colors.transparent,
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
