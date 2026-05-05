import 'package:flutter/material.dart';
import '../components/gradient_button.dart';
import '../components/student_button.dart';
import '../signup/signupteacher.dart';
import '../signup/signupstudent.dart';
import '../session/user_session.dart'; // ✅ ADDED

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
              // ── BACK Icon ──
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 24.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                  padding: const EdgeInsets.only(top: 250, left: 60, right: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // ── Teacher Button ──
                      GradientButton(
                        text: 'Sign up as a Teacher',
                        onPressed: () {
                          UserSession.role = 'teacher'; // ✅ Role set
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupTeacherScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // ── Student Button ──
                      StudentButton(
                        text: 'Sign up as a Student',
                        onPressed: () {
                          UserSession.role = 'student'; // ✅ Role set
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupStudentScreen(),
                            ),
                          );
                        },
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
