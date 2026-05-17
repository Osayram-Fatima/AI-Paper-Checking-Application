import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Import the reusable card ──
import 'package:ai_paper_checking/code/frontend/class_screen/class_card.dart';

// ── Data model for a class ──
class ClassModel {
  final String name;
  final int studentCount;

  const ClassModel({required this.name, required this.studentCount});
}

class SelectClassScreen extends StatefulWidget {
  const SelectClassScreen({super.key});

  @override
  State<SelectClassScreen> createState() => _SelectClassScreenState();
}

class _SelectClassScreenState extends State<SelectClassScreen> {
  // ── Sample Data ──
  final List<ClassModel> _allClasses = const [
    ClassModel(name: 'Class 2', studentCount: 30),
    ClassModel(name: 'Class 10', studentCount: 20),
    ClassModel(name: 'Class 2-A', studentCount: 32),
    ClassModel(name: 'Class 8', studentCount: 32),
  ];

  int? _selectedIndex;
  String _searchQuery = '';

  List<ClassModel> get _filteredClasses {
    if (_searchQuery.trim().isEmpty) return _allClasses;
    return _allClasses
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // ── Sizes & Spacing ──
  static const double topBarPaddingTop = 16;
  static const double topBarPaddingH = 20;
  static const double cardSpacing = 14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Same gradient bg as TeacherDashboard ──
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

          // ── Soft Glow Top Right ──
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

          // ── Soft Glow Bottom Left ──
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
                // ── Top Bar ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    topBarPaddingH,
                    topBarPaddingTop,
                    topBarPaddingH,
                    0,
                  ),
                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Title
                      Text(
                        'Select Class',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const Spacer(),

                      // Placeholder to balance row
                      const SizedBox(width: 44),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Search Bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: topBarPaddingH,
                  ),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.10),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Icons.search_rounded,
                          color: Colors.white.withOpacity(0.50),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Select your class ...',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.40),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            cursorColor: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Class List ──
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: topBarPaddingH,
                    ),
                    itemCount: _filteredClasses.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: cardSpacing),
                    itemBuilder: (context, index) {
                      final classItem = _filteredClasses[index];

                      // Find original index for selection tracking
                      final originalIndex = _allClasses.indexOf(classItem);

                      return ClassCard(
                        className: classItem.name,
                        studentCount: classItem.studentCount,
                        isSelected: _selectedIndex == originalIndex,
                        onTap: () =>
                            setState(() => _selectedIndex = originalIndex),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ── Add New Class Button ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.40),
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
                        highlightColor: Colors.white.withOpacity(0.08),
                        onTap: () {
                          // TODO: open Add New Class dialog/screen
                        },
                        child: Center(
                          child: Text(
                            'Add New Class +',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
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
}
