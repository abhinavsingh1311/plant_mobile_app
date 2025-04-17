import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/screens/profile_screen.dart';

void main() {
  late Widget app;

  setUp(() {
    app = const MaterialApp(
      home: ProfileScreen(),
    );
  });

  testWidgets("ProfileScreen should show basic layout",
      (WidgetTester tester) async {
    await tester.pumpWidget(app);

    expect(find.text('Profile'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets("ProfileScreen should have sign out button",
      (WidgetTester tester) async {
    await tester.pumpWidget(app);

    expect(find.text('Sign Out'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
  });
}
