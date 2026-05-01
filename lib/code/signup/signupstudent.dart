import 'package:ai_paper_checking/code/signup/Signupteacherprocess.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_paper_checking/code/components/student_button.dart';

class SignupStudentScreen extends StatelessWidget {
  const SignupStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ TEXT upar neeche — yeh badlo
    const double textTopOffset = 350.0;

    // ✅ BUTTON upar neeche — yeh badlo
    const double buttonBottomOffset = 150.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/signup_signin/teachersignup.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // ── 1. BACK Icon (✅ SAME AS SIGNUP SCREEN) ──
            Padding(
              padding: const EdgeInsets.only(
                top: 60,
                left: 20.0,
              ), // ✅ Same padding
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12), // ✅ Same padding
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      19,
                      2,
                      71,
                    ).withOpacity(0.3), // ✅ Same color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 24, // ✅ Same size
                  ),
                ),
              ),
            ),

            // ── 2. Title + Subtitle ──
            Positioned(
              top: 300,
              left: 30,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Getting Started',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 41,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Join now to stay connected with your classes, attendance, and learning updates in one place.',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 18,
                      height: 1.55,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5,
                    ),
                  ),
                ],
              ),
            ),

            // ── 3. Continue Button with Gradient Shadow ──
            Positioned(
              bottom: buttonBottomOffset,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 25,
                        spreadRadius: 0,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.15),
                        blurRadius: 35,
                        spreadRadius: -5,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 200,
                    child: StudentButton(
                      text: 'Continue',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupTeacherProcess(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
