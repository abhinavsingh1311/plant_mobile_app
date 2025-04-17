import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/models/plant_task.dart';

void main() {
  group('PlantTask Tests', () {
    test('Creates PlantTask from map', () {
      final now = DateTime.now();
      final map = {
        'type': 'watering',
        'completedDate': now.toIso8601String(),
        'notes': 'Test note',
      };

      final task = PlantTask.fromMap(map);

      expect(task.type, 'watering');
      expect(task.notes, 'Test note');
    });

    test('Converts PlantTask to map', () {
      final now = DateTime.now();
      final task = PlantTask(
        type: 'watering',
        completedDate: now,
        notes: 'Test note',
      );

      final map = task.toMap();

      expect(map['type'], 'watering');
      expect(map['notes'], 'Test note');
      expect(map['completedDate'], isA<String>());
    });
  });
}
