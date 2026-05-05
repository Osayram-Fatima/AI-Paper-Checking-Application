import 'package:ai_paper_checking/code/signin/studentlogin.dart';
import 'package:ai_paper_checking/code/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherLogin extends StatefulWidget {
  const TeacherLogin({super.key});

  @override
  State<TeacherLogin> createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin> {
  bool isTeacher = true;
  bool _passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LinearGradient customGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E3A8A),
      Color(0xFF1E3A8A),
      Color(0xFF9333EA),
    ],
    stops: [0.0, 0.4, 0.7, 1.0],
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffF5F6FA),
      body: Stack(
        children: [
          // Background decorative circles
          Positioned(top: -120, left: -80, child: _buildCircle(320)),
          Positioned(top: -100, right: -100, child: _buildCircle(320)),
          Positioned(bottom: -30, left: -30, child: _buildCircle(170)),
          Positioned(bottom: 120, left: 100, child: _buildCircle(60)),

          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SizedBox(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.31),

                    // Teacher / Student tab switcher
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTab("Teacher", isTeacher, () {
                          setState(() => isTeacher = true);
                        }),
                        const SizedBox(width: 35),
                        _buildTab("Student", !isTeacher, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StudentLogin(),
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 45),

                    _buildTextField("Email Address", _emailController),
                    const SizedBox(height: 25),
                    _buildTextField(
                      "Password",
                      _passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => _showForgotPasswordDialog(context),
                        child: Text(
                          "Forget your password?",
                          style: GoogleFonts.raleway(
                            color: const Color(0xFF1E3A8A),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Login button
                    Center(
                      child: Container(
                        width: 200,
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: customGradient,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E3A8A).withOpacity(0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => _handleTeacherLogin(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                          child: Text(
                            "Log-in",
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Sign up navigation
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: GoogleFonts.raleway(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: GoogleFonts.raleway(
                                  color: const Color(0xFF1E3A8A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
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
          ),
        ],
      ),
    );
  }

  // Teacher login handler — add your validation/navigation logic here
  void _handleTeacherLogin(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Navigate to TeacherDashboard after successful login
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const TeacherDashboard()),
    // );
  }

  // Forgot password dialog
  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Forgot Password?",
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "A reset link will be sent to your email.",
          style: GoogleFonts.raleway(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
            ),
            child: Text(
              "Send",
              style: GoogleFonts.raleway(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.raleway(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: active ? const Color(0xFF1E3A8A) : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          if (active)
            Container(
              height: 3,
              width: 90,
              decoration: BoxDecoration(
                gradient: customGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_passwordVisible,
      keyboardType: isPassword
          ? TextInputType.text
          : TextInputType.emailAddress,
      style: GoogleFonts.raleway(
        fontSize: 14,
        color: const Color(0xFF2B3A6B),
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
      ),
      cursorColor: const Color(0xFF1A2A5E),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: GoogleFonts.raleway(
          color: const Color(0xFF1E3A8A),
          fontWeight: FontWeight.w800,
          fontSize: 20,
          letterSpacing: 1,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF1E3A8A),
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _passwordVisible = !_passwordVisible),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF9333EA), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        filled: true,
        fillColor: const Color.fromARGB(99, 255, 255, 255),
      ),
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: customGradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
