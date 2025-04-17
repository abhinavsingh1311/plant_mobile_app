import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:plant_care_reminder_app/screens/profile_screen.dart';
import 'package:plant_care_reminder_app/providers/auth_provider.dart';
import 'package:plant_care_reminder_app/providers/plant_provider.dart';

void main() {
  group('ProfileScreen Tests', () {
    Widget createProfileScreen() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => PlantProvider()),
          ],
          child: const ProfileScreen(),
        ),
      );
    }

    testWidgets('Shows profile header', (WidgetTester tester) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget); // Sign Out button
    });

    testWidgets('Shows stats cards', (WidgetTester tester) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_florist), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
