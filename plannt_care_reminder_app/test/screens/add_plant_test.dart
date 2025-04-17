import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:plant_care_reminder_app/screens/add_plant.dart';
import 'package:plant_care_reminder_app/models/plant_guide.dart';
import 'package:plant_care_reminder_app/providers/plant_provider.dart';
import 'package:plant_care_reminder_app/providers/auth_provider.dart';

void main() {
  group('AddPlantScreen Tests', () {
    late PlantGuide testPlantGuide;
    late Widget testWidget;

    setUp(() {
      testPlantGuide = PlantGuide(
        name: 'Snake Plant',
        scientificName: 'Sansevieria',
        wateringFrequency: 'Weekly',
        lightRequirement: 'Low light',
      );

      testWidget = MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => PlantProvider()),
          ],
          child: AddPlantScreen(selectedPlant: testPlantGuide),
        ),
      );
    });

    testWidgets('Shows plant information', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      // Test plant info display
      expect(find.text('Sansevieria'), findsOneWidget);
      expect(find.text('Low light'), findsOneWidget);
      expect(find.text('Weekly'), findsOneWidget);
    });

    testWidgets('Shows form fields', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      expect(find.byType(TextFormField), findsOneWidget); // Custom name field
      expect(
          find.byType(ToggleButtons), findsOneWidget); // Indoor/Outdoor toggle
      expect(find.byType(ElevatedButton), findsOneWidget); // Add button
    });
  });
}
