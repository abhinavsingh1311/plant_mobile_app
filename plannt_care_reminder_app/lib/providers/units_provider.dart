import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnitsProvider with ChangeNotifier {
  String _selectedUnit = 'Metric';
  String get selectedUnit => _selectedUnit;

  UnitsProvider() {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedUnit = prefs.getString('units') ?? 'Metric';
    notifyListeners();
  }

  Future<void> setUnit(String unit) async {
    if (unit != _selectedUnit) {
      _selectedUnit = unit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('units', unit);
      notifyListeners();
    }
  }

  double convertTemperature(double celsius) {
    if (_selectedUnit == 'Imperial') {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  String formatTemperature(double celsius) {
    if (_selectedUnit == 'Imperial') {
      return '${convertTemperature(celsius).toStringAsFixed(1)}°F';
    }
    return '${celsius.toStringAsFixed(1)}°C';
  }
}
