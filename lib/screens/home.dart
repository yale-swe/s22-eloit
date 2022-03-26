import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eloit. Logged in'),
      ),
      body: ElevatedButton (
        child: Text('Log out'),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          // Now navigate to the auth page.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AuthBox(),
              ),
          );
        },
      )
    );
  }
}
