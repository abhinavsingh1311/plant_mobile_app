import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/providers/plant_provider.dart';
import 'package:plant_care_reminder_app/models/plant.dart';

void main() {
  group('PlantProvider Tests', () {
    late PlantProvider plantProvider;
    late Plant testPlant;

    setUp(() {
      plantProvider = PlantProvider();
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
    });

    test('Initial state should be empty', () {
      expect(plantProvider.plants, isEmpty);
      expect(plantProvider.isLoading, false);
    });

    test('getPlantsNeedingAttention returns plants needing water', () {
      final now = DateTime.now();
      final overduePlant = testPlant.copyWith(
          nextWaterDate: now.subtract(const Duration(days: 1)));

      plantProvider.plants.add(overduePlant);
      final needyPlants = plantProvider.getPlantsNeedingAttention();

      expect(needyPlants.length, 1);
      expect(needyPlants.first.id, '1');
    });

    test('getPlantsNeedingAttention returns unhealthy plants', () {
      final unhealthyPlant = testPlant.copyWith(healthStatus: 'Poor');

      plantProvider.plants.add(unhealthyPlant);
      final needyPlants = plantProvider.getPlantsNeedingAttention();

      expect(needyPlants.length, 1);
      expect(needyPlants.first.healthStatus, 'Poor');
    });

    test('getPlantsNeedingAttention returns plants needing pruning', () {
      final needsPruningPlant = testPlant.copyWith(
          lastPruned: DateTime.now().subtract(const Duration(days: 31)));

      plantProvider.plants.add(needsPruningPlant);
      final needyPlants = plantProvider.getPlantsNeedingAttention();

      expect(needyPlants.length, 1);
    });
  });
}
