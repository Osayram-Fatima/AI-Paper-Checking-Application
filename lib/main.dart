import 'package:flutter/material.dart';
import 'code/frontend/welcome/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Paper Checking App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      // ✅ Correct screen
      home: const WelcomeScreen(),

      debugShowCheckedModeBanner: false,
    );
  }
}
