import 'package:ai_paper_checking/code/signup/Signupteacherprocess.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_paper_checking/code/components/student_button.dart';

class SignupTeacherScreen extends StatelessWidget {
  const SignupTeacherScreen({super.key});

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
        // ✅ FIX: BoxDecoration se background image puri screen cover karegi
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/signup_signin/teachersignup.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // ── 1. BACK Button ──
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 28, left: 32.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'BACK',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 20,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // ── 2. Title + Subtitle ──
            Positioned(
              top: 340, // ✅ yeh badlo
              left: 30,
              right: 50,
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
                    'Sign up to streamline paper\nchecking and class management.',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 18,
                      height: 1.55,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ── 3. Continue Button ──
            Positioned(
              bottom: buttonBottomOffset, // ✅ yeh badlo
              left: 0,
              right: 0,
              child: Center(
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
          ],
        ),
      ),
    );
  }
}
