import 'package:ai_paper_checking/code/signin/signin.dart';
import 'package:ai_paper_checking/code/onboarding/onboarding_screen1.dart'; // ✅ ADD
import 'package:ai_paper_checking/code/session/user_session.dart'; // ✅ ADD
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupTeacherProcess extends StatefulWidget {
  const SignupTeacherProcess({super.key});

  @override
  State<SignupTeacherProcess> createState() => _SignupTeacherProcessState();
}

class _SignupTeacherProcessState extends State<SignupTeacherProcess> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;
  String? _selectedRole;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cnicController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ Validation + Navigation
  void _onNextPressed() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final cnic = _cnicController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    UserSession.firstName = firstName;
    UserSession.lastName = lastName;
    UserSession.email = email;
    UserSession.cnic = cnic;

    // ── Validation ──
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        cnic.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields and select a role',
            style: GoogleFonts.raleway(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1E3A8A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // ✅ Role save karo UserSession mein
    UserSession.role = _selectedRole!.toLowerCase(); // 'teacher' or 'student'

    // ✅ Onboarding screen 1 pe navigate karo
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen1()),
      (route) => false,
    );
  }

  // ── Text Field ──
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_passwordVisible,
      keyboardType: keyboardType,
      style: GoogleFonts.raleway(
        fontSize: 14,
        color: const Color(0xFF2B3A6B),
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
      ),
      cursorColor: const Color(0xFF1A2A5E),
      cursorWidth: 1.2,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: GoogleFonts.raleway(
          fontSize: 18,
          color: const Color(0xFF1A2A5E),
          fontWeight: FontWeight.w600,
          letterSpacing: 3,
        ),
        suffixIcon: isPassword
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    _passwordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF1A2A5E),
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1A2A5E), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1A2A5E), width: 1.2),
        ),
      ),
    );
  }

  // ── Role Spinner ──
  Widget _buildRoleSpinner() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      hint: const SizedBox.shrink(),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF1A2A5E),
        size: 22,
      ),
      dropdownColor: const Color(0xFFF0F4FF),
      style: GoogleFonts.raleway(
        fontSize: 14,
        color: const Color(0xFF2B3A6B),
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
      ),
      decoration: InputDecoration(
        labelText: 'role',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: GoogleFonts.raleway(
          fontSize: 18,
          color: const Color(0xFF1A2A5E),
          fontWeight: FontWeight.w600,
          letterSpacing: 3,
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1A2A5E), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1A2A5E), width: 1.2),
        ),
      ),
      items: ['Teacher', 'Student'].map((role) {
        return DropdownMenuItem(
          value: role,
          child: Text(
            role,
            style: GoogleFonts.raleway(
              fontSize: 14,
              color: const Color(0xFF1A2A5E),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        );
      }).toList(),
      onChanged: (val) => setState(() => _selectedRole = val),
    );
  }

  // ── Already have account ──
  Widget _buildLoginToggle() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SigninScreen()),
        );
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.raleway(
            fontSize: 16,
            color: const Color(0xFF1A2A5E),
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          children: const [
            TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Color(0xFF9333EA),
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/signup_signin/teachersignuppg2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── BACK Button ──
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
                      ).withOpacity(0.2),
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

              const SizedBox(height: 70),

              // ── Main Container ──
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF0F4FF), Color(0xFFE8EEF8)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(56),
                      topRight: Radius.circular(56),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Getting Started',
                          style: GoogleFonts.raleway(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A2A5E),
                            letterSpacing: 0.8,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Access your dashboard to manage\nclasses and review papers',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A2A5E),
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                        ),

                        const SizedBox(height: 32),

                        _buildField(
                          label: 'first name',
                          controller: _firstNameController,
                        ),
                        const SizedBox(height: 25),

                        _buildField(
                          label: 'Last name',
                          controller: _lastNameController,
                        ),
                        const SizedBox(height: 25),

                        _buildField(
                          label: 'CNIC',
                          controller: _cnicController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 25),

                        _buildField(
                          label: 'Email Address',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 25),

                        _buildField(
                          label: 'password',
                          controller: _passwordController,
                          isPassword: true,
                        ),
                        const SizedBox(height: 25),

                        _buildRoleSpinner(),
                        const SizedBox(height: 40),

                        // ── NEXT Button ──
                        Center(
                          child: Container(
                            width: 190,
                            height: 53,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF0F172A),
                                  Color(0xFF1E3A8A),
                                  Color(0xFF1E3A8A),
                                  Color(0xFF9333EA),
                                ],
                                stops: [0.0, 0.4, 0.7, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF1E3A8A,
                                  ).withOpacity(0.6),
                                  blurRadius: 10,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: _onNextPressed, // ✅ FIXED
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'NEXT',
                                style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3.0,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        _buildLoginToggle(),

                        const SizedBox(height: 20),
                      ],
                    ),
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
