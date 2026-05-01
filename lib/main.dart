import 'package:flutter/material.dart';
import 'code/welcome/welcome_screen.dart'; // Import your custom screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome App',
      theme: ThemeData(
        // Set a default theme, but we'll mostly use custom colors
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // Set your custom screen as the home
      debugShowCheckedModeBanner: false, // Hide the debug banner
    );
  }
}
