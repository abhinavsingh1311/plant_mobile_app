import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/models/plant_guide.dart';

void main() {
  group('PlantGuide Tests', () {
    test('Creates PlantGuide from map', () {
      final map = {
        'common_name': 'Snake Plant',
        'scientific_name': ['Sansevieria trifasciata'],
        'watering': 'Weekly',
        'sunlight': ['Low light'],
        'default_image': {'regular_url': 'test.jpg'},
      };

      final guide = PlantGuide.fromMap(map);

      expect(guide.name, 'Snake Plant');
      expect(guide.scientificName, 'Sansevieria trifasciata');
      expect(guide.wateringFrequency, 'Weekly');
      expect(guide.lightRequirement, 'Low light');
      expect(guide.imageUrl, 'test.jpg');
    });

    test('Handles missing or null values', () {
      final map = {
        'common_name': 'Snake Plant',
      };

      final guide = PlantGuide.fromMap(map);

      expect(guide.name, 'Snake Plant');
      expect(guide.scientificName, '');
      expect(guide.wateringFrequency, 'Average');
      expect(guide.lightRequirement, 'Moderate light');
      expect(guide.imageUrl, null);
    });
  });
}
