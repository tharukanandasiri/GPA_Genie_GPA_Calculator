import 'package:flutter/material.dart';
import 'result_screen.dart';
import '../models/course.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  // List to store course details
  final List<Course> _courses =
      List.generate(6, (_) => Course(name: '', credit: 0, grade: 'A+'));
  // List of grades
  final List<String> _grades = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D+',
    'D',
    'E'
  ];

  // GPA Map
  final Map<String, double> _gradePoints = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1.0,
    'E': 0.7
  };

  final List<TextEditingController> _creditControllers =
      List.generate(6, (_) => TextEditingController());

  // Validity of credit input
  final List<bool> _isCreditValid = List.filled(6, true);

  // Function to calculate GPA
  void _calculateGPA() {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var course in _courses) {
      totalPoints += course.credit * _gradePoints[course.grade]!;
      totalCredits += course.credit;
    }

    double gpa = totalCredits > 0 ? totalPoints / totalCredits : 0;

    // Navigate to the result screen with the calculated GPA
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(gpa: gpa),
      ),
    );
  }

  // Function to clear all input fields
  void _clearFields() {
    setState(() {
      for (var controller in _creditControllers) {
        controller.clear();
      }
      for (var course in _courses) {
        course.name = '';
        course.credit = 0;
        course.grade = 'A+';
      }
      _isCreditValid.fillRange(0, _isCreditValid.length, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                  text: 'GPA ',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent)),
              TextSpan(
                  text: 'Genie',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent)),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildTableHeader(),
                  for (int i = 0; i < _courses.length; i++) _buildCourseRow(i),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Buttons for calculating GPA and clearing fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton('Calculate GPA', Colors.blueAccent, _calculateGPA),
                _buildButton('Clear', Colors.redAccent, _clearFields),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display table headers
  Widget _buildTableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
            flex: 2,
            child: Text('Course',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
        Expanded(
            child: Text('Credits',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
        Expanded(
            child: Text('Grade',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
      ],
    );
  }

  // Widget to create a row for each course input
  Widget _buildCourseRow(int index) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Course name input field
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Course ${index + 1}',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (value) => _courses[index].name = value,
              ),
            ),
            const SizedBox(width: 10),
            // Credit input field
            Expanded(
              child: TextField(
                controller: _creditControllers[index],
                decoration: InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: _isCreditValid[index] ? Colors.grey : Colors.red,
                        width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _isCreditValid[index] = RegExp(r'^\d+$').hasMatch(value);
                    if (_isCreditValid[index]) {
                      _courses[index].credit = int.tryParse(value) ?? 0;
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            // Grade dropdown selection
            Expanded(
              child: DropdownButtonFormField(
                value: _courses[index].grade,
                items: _grades.map((grade) {
                  return DropdownMenuItem(value: grade, child: Text(grade));
                }).toList(),
                onChanged: (value) =>
                    setState(() => _courses[index].grade = value.toString()),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Button widget
  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        elevation: 4,
      ),
      child:
          Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}
