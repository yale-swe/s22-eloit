import 'package:eloit/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eloit/screens/home.dart';

Widget createHomeScreen() => const MaterialApp(home: Home());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  group('Home Page Widget Tests', () {
    testWidgets('Test for appbar with title', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text('Eloit. Logged in'), findsOneWidget);
    });
  });
}