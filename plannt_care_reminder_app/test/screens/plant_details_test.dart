import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:plant_care_reminder_app/screens/plant_details.dart';
import 'package:plant_care_reminder_app/models/plant.dart';
import 'package:plant_care_reminder_app/providers/plant_provider.dart';
import 'package:plant_care_reminder_app/providers/auth_provider.dart';

void main() {
  group('PlantDetailsScreen Tests', () {
    late Plant testPlant;
    late Widget testWidget;

    setUp(() {
      final now = DateTime.now();
      testPlant = Plant(
        id: '1',
        name: 'Test Plant',
        species: 'Test Species',
        imageUrl: 'test.jpg',
        isIndoor: true,
        lightRequirement: 'Medium',
        wateringFrequency: 'Weekly',
        lastWatered: now,
        nextWaterDate: now.add(const Duration(days: 7)),
        addedDate: now,
        healthStatus: 'Good',
      );

      testWidget = MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => PlantProvider()),
          ],
          child: PlantDetailsScreen(plant: testPlant),
        ),
      );
    });

    testWidgets('Shows plant details', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      expect(find.text('Test Plant'), findsOneWidget);
      expect(find.text('Test Species'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget); // Water Now button
    });

    testWidgets('Shows care instructions', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      expect(find.text('Care Tips'), findsOneWidget);
      expect(find.byIcon(Icons.water_drop), findsOneWidget);
    });
  });
}
