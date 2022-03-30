import 'package:eloit/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDmiVNPu9XHzrxxaGLbc3OYAu9YWogrPHM",
      authDomain: "eloit-c4540.firebaseapp.com",
      projectId: "eloit-c4540",
      storageBucket: "eloit-c4540.appspot.com",
      messagingSenderId: "705214352014",
      appId: "1:705214352014:web:45d2d32d357cae57ee17df",
      measurementId: "G-VJ6E55K7C1",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eloit',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const Wrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
