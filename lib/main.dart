import 'package:flutter/material.dart';
import 'screens/input_screen.dart';

void main() {
  runApp(const GPACalculatorApp());
}

// The main app widget
class GPACalculatorApp extends StatelessWidget {
  const GPACalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Genie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InputScreen(),
    );
  }
}
