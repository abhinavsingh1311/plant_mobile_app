import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:plant_care_reminder_app/screens/plants_screen.dart';
import 'package:plant_care_reminder_app/providers/auth_provider.dart';
import 'package:plant_care_reminder_app/providers/plant_provider.dart';

void main() {
  group('PlantsScreen Tests', () {
    Widget createPlantsScreen() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => PlantProvider()),
          ],
          child: const PlantsScreen(),
        ),
      );
    }

    testWidgets('Shows empty state when no plants',
        (WidgetTester tester) async {
      await tester.pumpWidget(createPlantsScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_florist_outlined), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Shows filter toggle', (WidgetTester tester) async {
      await tester.pumpWidget(createPlantsScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });
  });
}
