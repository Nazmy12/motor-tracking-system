import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gocheck/main.dart';

void main() {
  testWidgets('App launches and shows login page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login page is shown
    expect(find.text('GoCheck'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text("Don’t have an account?"), findsOneWidget);
    expect(find.text("Sign Up"), findsOneWidget);
  });
}
