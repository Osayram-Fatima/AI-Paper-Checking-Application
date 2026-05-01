import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// 👇 imports
import '../signup/signup.dart';
import 'package:ai_paper_checking/code/signin/signin.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color signUpTextColor = Color(0xFF4A68C3);
    const Color signUpButtonColor = Color(0xFFE4E4E4);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/welcome_screen/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Center(
                        child: DefaultTextStyle(
                          style: GoogleFonts.poppins(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'Welcome !',
                                speed: const Duration(milliseconds: 350),
                                cursor: '|',
                              ),
                            ],
                            isRepeatingAnimation: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'Your check-in experience\nstarts here.....',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 👇 Navigation updated here
              AnimatedBottomActions(
                onSignIn: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SigninScreen(),
                    ),
                  );
                },
                onSignUp: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedBottomActions extends StatefulWidget {
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  const AnimatedBottomActions({
    super.key,
    required this.onSignIn,
    required this.onSignUp,
  });

  @override
  State<AnimatedBottomActions> createState() => _AnimatedBottomActionsState();
}

class _AnimatedBottomActionsState extends State<AnimatedBottomActions> {
  bool isHoveringSignIn = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double height = 100;
    final double buttonWidth = screenWidth / 2;
    const Color signUpTextColor = Color(0xFF4A68C3);
    const Color signUpButtonColor = Color(0xFFE4E4E4);

    return SizedBox(
      height: height,
      width: screenWidth,
      child: MouseRegion(
        onExit: (_) => setState(() => isHoveringSignIn = false),
        child: Stack(
          children: [
            // Sliding Background
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isHoveringSignIn ? 0 : screenWidth - buttonWidth,
              bottom: 0,
              width: buttonWidth,
              height: height,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: signUpButtonColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(isHoveringSignIn ? 40 : 0),
                    topLeft: Radius.circular(isHoveringSignIn ? 0 : 40),
                  ),
                ),
              ),
            ),

            // Buttons
            Row(
              children: [
                // Sign in
                Expanded(
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHoveringSignIn = true),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() => isHoveringSignIn = true);
                        widget.onSignIn();
                      },
                      child: Container(
                        height: height,
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 50),
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isHoveringSignIn
                                ? signUpTextColor
                                : Colors.white,
                          ),
                          child: const Text('Sign in'),
                        ),
                      ),
                    ),
                  ),
                ),

                // Sign up
                Expanded(
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHoveringSignIn = false),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() => isHoveringSignIn = false);
                        widget.onSignUp();
                      },
                      child: Container(
                        height: height,
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: !isHoveringSignIn
                                ? signUpTextColor
                                : Colors.white,
                          ),
                          child: const Text('Sign up'),
                        ),
                      ),
                    ),
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
