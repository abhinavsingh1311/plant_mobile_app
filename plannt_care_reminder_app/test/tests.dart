// test/test.dart (Main test file)
import 'package:flutter_test/flutter_test.dart';

// Models
import 'models/plant_test.dart' as plant_test;
import 'models/plant_task_test.dart' as plant_task_test;
import 'models/plant_guide_test.dart' as plant_guide_test;
import 'models/user_profile_test.dart' as user_profile_test;

// Widgets
import 'widgets/plant_card_test.dart' as plant_card_test;

// Screens
import 'screens/home_screen_test.dart' as home_screen_test;
import 'screens/profile_screen_test.dart' as profile_screen_test;
import 'screens/setting_screen_test.dart' as settings_screen_test;
import 'screens/login_screen_test.dart' as login_screen_test;
import 'screens/register_screen_test.dart' as register_screen_test;
import 'screens/add_plant_test.dart' as add_plant_screen_test;
import 'screens/plant_details_test.dart' as plant_details_screen_test;
import 'screens/plants_screen_test.dart' as plants_screen_test;
import 'screens/search_plant_test.dart' as search_plant_test;

// Providers
import 'provider/auth_provider_test.dart' as auth_provider_test;
import 'provider/plant_provider_test.dart' as plant_provider_test;
import 'provider/theme_provider_test.dart' as theme_provider_test;
import 'provider/units_provider_test.dart' as units_provider_test;

void main() {
  group('All Tests', () {
    group('Model Tests', () {
      plant_test.main();
      plant_task_test.main();
      plant_guide_test.main();
      user_profile_test.main();
    });

    group('Widget Tests', () {
      plant_card_test.main();
    });

    group('Screen Tests', () {
      home_screen_test.main();
      profile_screen_test.main();
      settings_screen_test.main();
      login_screen_test.main();
      register_screen_test.main();
      add_plant_screen_test.main();
      plant_details_screen_test.main();
      plants_screen_test.main();
      search_plant_test.main();
    });

    group('Provider Tests', () {
      auth_provider_test.main();
      plant_provider_test.main();
      theme_provider_test.main();
      units_provider_test.main();
    });
  });
}
