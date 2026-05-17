import 'package:flutter/material.dart';
import 'package:ai_paper_checking/code/frontend/dashboard/signupdash/studentsignupdash/HomeScreen.dart';
import 'package:ai_paper_checking/code/frontend/dashboard/signupdash/studentsignupdash/ResultsScreen.dart';
import 'package:ai_paper_checking/code/frontend/dashboard/signupdash/studentsignupdash/SubjectsScreen.dart';
import 'package:ai_paper_checking/code/frontend/dashboard/signupdash/studentsignupdash/PaperUploadScreen.dart';
import 'package:ai_paper_checking/code/frontend/dashboard/signupdash/studentsignupdash/StudentProfileScreen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({
    super.key,
  }); // ✅ user parameter hataya — UserSession se milega
  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ResultsScreen(),
    SubjectsScreen(),
    PaperUploadScreen(),
    StudentProfileScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_rounded, 'label': "HOME"},
    {'icon': Icons.bar_chart_rounded, 'label': "RESULTS"},
    {'icon': Icons.menu_book_rounded, 'label': "SUBJECTS"},
    {'icon': Icons.upload_file_rounded, 'label': "PAPER"},
    {'icon': Icons.person_rounded, 'label': "PROFILE"},
  ];

  @override
  Widget build(BuildContext context) {
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
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

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
            behavior: HitTestBehavior.opaque,
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
