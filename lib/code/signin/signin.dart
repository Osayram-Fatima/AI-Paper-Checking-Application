import 'package:ai_paper_checking/code/signin/teacherlogin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/gradient_button.dart';
import '../components/student_button.dart';
import '../signup/signupteacher.dart'; // ✅ Correct filename
import '../signup/signupstudent.dart'; // ✅ Correct filename

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/signup_signin/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── BACK Icon (Updated) ──
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 24.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        19,
                        2,
                        71,
                      ).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 250,
                    left: 60,
                    right: 60,
                  ), // ✅ Top spacing control
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // ✅ TOP par aayenge
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // ✅ Full width
                    children: [
                      const SizedBox(height: 20), // ✅ Extra top space
                      GradientButton(
                        text: 'Continue as a Teacher',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TeacherLogin(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      StudentButton(
                        text: 'Continue as a Student',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupStudentScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
