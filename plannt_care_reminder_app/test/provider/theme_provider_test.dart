import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plant_care_reminder_app/providers/theme_provider.dart';

void main() {
  group('ThemeProvider Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial theme mode is light', () {
      final provider = ThemeProvider();
      expect(provider.isDarkMode, false);
    });

    test('Can toggle theme mode', () {
      final provider = ThemeProvider();
      provider.setDarkMode(true);
      expect(provider.isDarkMode, true);
    });
  });
}
