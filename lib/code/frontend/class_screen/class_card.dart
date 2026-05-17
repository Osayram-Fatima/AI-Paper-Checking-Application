import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassCard extends StatelessWidget {
  final String className;
  final int studentCount;
  final bool isSelected;
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.className,
    required this.studentCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        scale: isSelected ? 1.02 : 1,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,

          width: double.infinity,

          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            // ✅ Selected Gradient
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5B5CFF),
                      Color(0xFF7C4DFF),
                      Color(0xFFB84DFF),
                    ],
                  )
                // ✅ Normal Glass Effect
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.10),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),

            // ✅ Border
            border: Border.all(
              color: isSelected
                  ? Colors.white.withOpacity(0.14)
                  : Colors.white.withOpacity(0.08),
              width: 1.2,
            ),

            // ✅ Shadow
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF6D5DFB).withOpacity(0.40),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Leading Icon Box
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),

                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.16)
                      : Colors.white.withOpacity(0.06),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: isSelected ? 24 : 22,
                ),
              ),

              const SizedBox(width: 14),

              // ✅ Text Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      className,

                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      '$studentCount Students',

                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(
                          isSelected ? 0.90 : 0.58,
                        ),

                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Selected Check
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),

                child: isSelected
                    ? Container(
                        key: const ValueKey(true),

                        width: 38,
                        height: 38,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF5B5CFF),
                          size: 22,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
