import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eloit/screens/home.dart';
import 'package:eloit/setup_firestore.dart';
import 'mock.dart';

Widget createHomeScreen() => const MaterialApp(home: Home());

// https://stackoverflow.com/questions/63662031/how-to-mock-the-firebaseapp-in-flutter
void main() async {
  setupFirebaseAuthMocks();
  setupKiwi();
  WidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // Removed test that searched for the app name on the home page (which is currently the Avengers category page)
  group('Home Page Widget Tests', () {});
}
