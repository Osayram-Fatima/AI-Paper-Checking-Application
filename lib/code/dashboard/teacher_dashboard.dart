import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_paper_checking/code/session/user_session.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;

  // ── Nav item data ──
  final List<Map<String, dynamic>> _navItems = [
    {'label': 'Home', 'icon': 'lib/assets/icons/nav/HOME.png'},
    {'label': 'Attendance', 'icon': 'lib/assets/icons/nav/ATTENDENCE.png'},
    {'label': 'Paper', 'icon': 'lib/assets/icons/nav/PAPER.png'},
    {'label': 'Students', 'icon': 'lib/assets/icons/nav/STUDNET.png'},
    {'label': 'Profile', 'icon': 'lib/assets/icons/nav/PROFILE.png'},
  ];

  // ── Greeting ──
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // ── Teacher name from UserSession ──
  String get _teacherName {
    final first = UserSession.firstName ?? '';
    final last = UserSession.lastName ?? '';
    final full = '$first $last'.trim();
    return full.isNotEmpty ? full : 'Teacher';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1437),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _selectedIndex == 0
                  ? _buildHomeBody()
                  : _buildComingSoon(_navItems[_selectedIndex]['label']),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── TOP BAR ──
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hamburger
          Icon(Icons.menu_rounded, color: Colors.white, size: 38),

          // Bell
          const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 36,
          ),
        ],
      ),
    );
  }

  // ── HOME BODY ──
  Widget _buildHomeBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting Row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: GoogleFonts.raleway(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mam $_teacherName',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Here is what happening today',
                      style: GoogleFonts.raleway(
                        color: Colors.white60,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Profile Avatar (blank / placeholder) ──
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E3A8A),
                  border: Border.all(
                    color: const Color(0xFF9333EA),
                    width: 2.5,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white54,
                  size: 36,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ── No Classes Card ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A2A6C), Color(0xFF1E3A8A)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E3A8A).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Folder illustration
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Icon(
                      Icons.folder_special_rounded,
                      color: const Color(0xFF9333EA),
                      size: 72,
                    ),
                    // Sparkles
                    Positioned(
                      top: 0,
                      right: 20,
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.white54,
                        size: 14,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 14,
                      child: Icon(
                        Icons.star_rounded,
                        color: const Color(0xFF9333EA),
                        size: 10,
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 10,
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.white38,
                        size: 8,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'No Classes Yet!',
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Add your first class to start\nmanaging students, papers and\nattendance.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    color: Colors.white60,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Add Class Button ──
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF1E3A8A), Color(0xFF9333EA)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9333EA).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to Add Class screen
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
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
                          'Add Class',
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Coming Soon placeholder for other tabs ──
  Widget _buildComingSoon(String label) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.construction_rounded, color: Colors.white30, size: 60),
          const SizedBox(height: 16),
          Text(
            '$label\nComing Soon',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              color: Colors.white38,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ──
  Widget _buildBottomNav() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Nav Icon from asset ──
                  ColorFiltered(
                    colorFilter: isSelected
                        ? const ColorFilter.mode(
                            Color(0xFF1E3A8A),
                            BlendMode.srcIn,
                          )
                        : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    child: Image.asset(
                      _navItems[index]['icon'],
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.circle_outlined,
                        size: 24,
                        color: isSelected
                            ? const Color(0xFF1E3A8A)
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _navItems[index]['label'],
                    style: GoogleFonts.raleway(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey,
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
