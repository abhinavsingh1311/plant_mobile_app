import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:plant_care_reminder_app/providers/auth_provider.dart';
import 'package:plant_care_reminder_app/screens/register.dart';

void main() {
  group('RegisterScreen Tests', () {
    Widget createRegisterScreen() {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: const RegisterScreen(),
        ),
      );
    }

    testWidgets('Shows form fields', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterScreen());

      // Find form fields by key or type
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Find labels using specific text that won't be duplicated
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('Validates empty form', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterScreen());

      // Try to submit empty form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check for validation messages
      expect(find.text('Please enter your name'), findsOneWidget);
    });
  });
}
