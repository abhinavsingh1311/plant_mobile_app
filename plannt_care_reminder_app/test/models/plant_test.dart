import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/models/plant.dart';

void main() {
  group('Plant Model Tests', () {
    test('Creates Plant from map', () {
      final now = DateTime.now();
      final map = {
        'id': '1',
        'name': 'Test Plant',
        'species': 'Test Species',
        'imageUrl': 'test.jpg',
        'isIndoor': true,
        'lightRequirement': 'Medium',
        'wateringFrequency': 'Weekly',
        'lastWatered': now.toIso8601String(),
        'nextWaterDate': now.add(const Duration(days: 7)).toIso8601String(),
        'addedDate': now.toIso8601String(),
        'healthStatus': 'Good',
        'completedTasks': [],
      };

      final plant = Plant.fromMap(map);

      expect(plant.id, '1');
      expect(plant.name, 'Test Plant');
      expect(plant.species, 'Test Species');
      expect(plant.isIndoor, true);
    });

    test('Converts Plant to map', () {
      final now = DateTime.now();
      final plant = Plant(
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

      final map = plant.toMap();

      expect(map['name'], 'Test Plant');
      expect(map['species'], 'Test Species');
      expect(map['isIndoor'], true);
    });
  });
}
