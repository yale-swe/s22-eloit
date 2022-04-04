import 'package:eloit/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eloit/screens/home.dart';
import 'package:eloit/shared/mock.dart';

Widget createHomeScreen() => const MaterialApp(home: Home());

void main() async {
  setupFirebaseAuthMocks();
  WidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Home Page Widget Tests', () {
    testWidgets('Test for appbar with title', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text('Eloit. Logged in'), findsOneWidget);
    });
  });
}
