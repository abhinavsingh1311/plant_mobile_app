import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plant_care_reminder_app/providers/units_provider.dart';

void main() {
  group('UnitsProvider Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Default unit is Metric', () {
      final provider = UnitsProvider();
      expect(provider.selectedUnit, 'Metric');
    });

    test('Can switch units', () {
      final provider = UnitsProvider();
      provider.setUnit('Imperial');
      expect(provider.selectedUnit, 'Imperial');
    });
  });
}
