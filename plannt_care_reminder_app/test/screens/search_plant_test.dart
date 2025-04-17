import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care_reminder_app/screens/search_plant.dart';

void main() {
  group('PlantSearchScreen Tests', () {
    testWidgets('Shows search bar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: PlantSearchScreen(),
      ));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Shows loading state during search',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: PlantSearchScreen(),
      ));

      // Enter search text
      await tester.enterText(find.byType(TextField), 'Monstera');
      await tester.pump();

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
