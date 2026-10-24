import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:demo/main.dart';

void main() {
  testWidgets('FoodLoopApp smoke test loads login screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FoodLoopApp());

    // Verify that the login screen title and components are present.
    expect(find.text('Welcome to FoodLoop'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
