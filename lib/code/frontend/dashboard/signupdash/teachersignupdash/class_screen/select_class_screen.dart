// lib/code/frontend/screens/SelectClassScreen.dart
// ─────────────────────────────────────────────────────────────
//  Teacher's "Select Class" screen.
//  • Lists all teacher classes fetched from the backend.
//  • Tapping a class saves it locally and pops with the result.
//  • FAB opens the "Create Class" bottom-sheet.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_paper_checking/code/frontend/services/class_service.dart';
import 'package:ai_paper_checking/code/frontend/session/class_preferences.dart';

class SelectClassScreen extends StatefulWidget {
  const SelectClassScreen({super.key});

  @override
  State<SelectClassScreen> createState() => _SelectClassScreenState();
}

class _SelectClassScreenState extends State<SelectClassScreen> {
  List<ClassModel> _classes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final classes = await ClassService.fetchMyClasses();
      if (mounted)
        setState(() {
          _classes = classes;
          _loading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _error = e.toString();
          _loading = false;
        });
    }
  }

  Future<void> _selectClass(ClassModel cls) async {
    await ClassPreferences.saveSelectedClass(cls);
    if (mounted) Navigator.pop(context, cls);
  }

  void _showCreateDialog() {
    final nameCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    bool creating = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E1B4B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Drag handle ──
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Create New Class',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'A unique join code will be generated automatically.',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),

                _buildField(nameCtrl, 'Class Name', 'e.g. Class 9-A', false),
                const SizedBox(height: 16),
                _buildField(
                  subjectCtrl,
                  'Subject (optional)',
                  'e.g. Mathematics',
                  false,
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: creating
                        ? null
                        : () async {
                            if (nameCtrl.text.trim().isEmpty) return;
                            setSheetState(() => creating = true);
                            try {
                              final cls = await ClassService.createClass(
                                className: nameCtrl.text.trim(),
                                subjectName: subjectCtrl.text.trim().isEmpty
                                    ? null
                                    : subjectCtrl.text.trim(),
                              );
                              if (mounted) {
                                Navigator.pop(ctx);
                                await _selectClass(cls);
                              }
                            } catch (e) {
                              setSheetState(() => creating = false);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                    child: creating
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Create Class',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    String hint,
    bool obscure,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 14),
            filled: true,
            fillColor: Colors.white.withOpacity(0.07),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF6366F1),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Class',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
            onPressed: _loadClasses,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'New Class',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            )
          : _error != null
          ? _buildError()
          : _classes.isEmpty
          ? _buildEmpty()
          : _buildList(),
    );
  }

  Widget _buildError() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.wifi_off_rounded, color: Colors.white38, size: 52),
        const SizedBox(height: 12),
        Text(
          _error!,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: _loadClasses,
          child: Text(
            'Retry',
            style: GoogleFonts.poppins(color: const Color(0xFF6366F1)),
          ),
        ),
      ],
    ),
  );

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.class_outlined, color: Colors.white24, size: 64),
        const SizedBox(height: 16),
        Text(
          'No classes yet',
          style: GoogleFonts.poppins(
            color: Colors.white60,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the button below to create your first class.',
          style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildList() => ListView.builder(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
    itemCount: _classes.length,
    itemBuilder: (_, i) => _ClassCard(
      cls: _classes[i],
      onTap: () => _selectClass(_classes[i]),
      onDelete: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color(0xFF1E1B4B),
            title: Text(
              'Delete class?',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            content: Text(
              'All students, papers, and attendance data will be permanently removed.',
              style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: GoogleFonts.poppins(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        );
        if (confirm == true) {
          try {
            await ClassService.deleteClass(_classes[i].classId);
            await _loadClasses();
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }
        }
      },
    ),
  );
}

// ── Class Card ────────────────────────────────────────────────

class _ClassCard extends StatelessWidget {
  final ClassModel cls;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ClassCard({
    required this.cls,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.09),
              Colors.white.withOpacity(0.04),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            // ── Color dot ──
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5)],
                ),
              ),
              child: Center(
                child: Text(
                  cls.className.substring(0, 1).toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ── Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cls.className,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (cls.subjectName != null && cls.subjectName!.isNotEmpty)
                    Text(
                      cls.subjectName!,
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Join code chip
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: cls.joinCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Join code copied: ${cls.joinCode}',
                                style: GoogleFonts.poppins(),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                cls.joinCode,
                                style: GoogleFonts.sourceCodePro(
                                  color: const Color(0xFFA5B4FC),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.copy_rounded,
                                size: 12,
                                color: Color(0xFFA5B4FC),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.people_rounded,
                        size: 14,
                        color: Colors.white38,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${cls.studentCount}',
                        style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Actions ──
            Column(
              children: [
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white30,
                  size: 16,
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
