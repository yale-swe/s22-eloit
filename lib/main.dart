import 'package:eloit/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
