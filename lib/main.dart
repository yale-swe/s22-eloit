import 'package:eloit/screens/home.dart';
import 'package:eloit/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'setup_firestore.dart';
import 'firebase_options.dart';
import 'ioc_locator.dart';

bool USE_FIRESTORE_EMULATOR = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  iocLocator();

  if (USE_FIRESTORE_EMULATOR) {
    print("using firestore emulator");
    FirebaseFirestore.instance.settings = const Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    await generateRivalry();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const Wrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
