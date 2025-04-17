import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/providers/auth_provider.dart';
import 'package:plant_care_reminder_app/providers/plant_provider.dart';
import 'package:plant_care_reminder_app/providers/theme_provider.dart';
import 'package:plant_care_reminder_app/providers/units_provider.dart';
import 'package:provider/provider.dart';
import 'package:plant_care_reminder_app/screens/home.dart';

void main() {
  testWidgets('HomeScreen navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => PlantProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => UnitsProvider()),
          ],
          child: const HomeScreen(),
        ),
      ),
    );

    // Test bottom navigation
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.local_florist), findsOneWidget);
  });
}
