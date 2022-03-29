import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eloit/screens/home.dart';

Widget createHomeScreen() => const MaterialApp(home: Home());

void main() {
  group('Home Page Widget Tests', () {
    testWidgets('Test for appbar with title', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text('Eloit. Logged in'), findsOneWidget);
    });
  });
}