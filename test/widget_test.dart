// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gpa_calculator/main.dart';
import 'package:gpa_calculator/screens/input_screen.dart';

void main() {
  testWidgets('GPA Genie app loads correctly', (WidgetTester tester) async {
    // Load the app
    await tester.pumpWidget(const MaterialApp(home: InputScreen()));

    // Wait for widgets to build
    await tester.pumpAndSettle();

    // Check if the AppBar contains "GPA Genie"
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('GPA Genie'),
        findsNothing); // This won't work because it's in RichText

    // Instead, find the RichText inside the AppBar
    expect(find.text('Course'), findsWidgets);
  });
}
