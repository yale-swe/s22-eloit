import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eloit/screens/home.dart';
import 'package:flutter/material.dart';

Widget createHomeScreen() => const MaterialApp(home: Home());

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding; // NEW

  testWidgets("failing test example", (WidgetTester tester) async {
    expect(2 + 2, equals(4));
  });

  group('Home Page Widget Tests', () {
    testWidgets('Test for appbar with title', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text(APP_NAME), findsOneWidget);
    });
  });
}
