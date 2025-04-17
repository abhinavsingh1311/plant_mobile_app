import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/providers/auth_provider.dart';

void main() {
  group('AuthProvider Tests', () {
    test('Initial state is correct', () {
      final provider = AuthProvider();
      expect(provider.isAuthenticated, false);
      expect(provider.userProfile, null);
      expect(provider.isInitializing, true);
    });
  });
}
