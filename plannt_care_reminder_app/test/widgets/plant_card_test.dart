import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/widgets/plant_card.dart';
import 'package:plant_care_reminder_app/models/plant.dart';

void main() {
  testWidgets('PlantCard displays plant information',
      (WidgetTester tester) async {
    final plant = Plant(
      id: '1',
      name: 'Test Plant',
      species: 'Test Species',
      imageUrl: '',
      isIndoor: true,
      lightRequirement: 'Medium',
      wateringFrequency: 'Weekly',
      lastWatered: DateTime.now(),
      nextWaterDate: DateTime.now().add(const Duration(days: 7)),
      addedDate: DateTime.now(),
      healthStatus: 'Good',
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PlantCard(plant: plant),
      ),
    ));

    expect(find.text('Test Plant'), findsOneWidget);
    expect(find.text('Test Species'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });
}
