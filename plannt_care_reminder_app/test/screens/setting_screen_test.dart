import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/providers/auth_provider.dart';
import 'package:plant_care_reminder_app/providers/theme_provider.dart';
import 'package:plant_care_reminder_app/providers/units_provider.dart';
import 'package:provider/provider.dart';
import 'package:plant_care_reminder_app/screens/settings.dart';

void main() {
  testWidgets('SettingsScreen test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => UnitsProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const SettingsScreen(),
        ),
      ),
    );

    // Test presence of settings options
    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsOneWidget);
  });
}
