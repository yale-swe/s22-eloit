import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


const String APP_NAME = 'EloRanker';

const Color COLOR_BACKGROUND = Color(0xFF000452);
const Color COLOR_OBJECTS = Color(0xFF00FF04);
const Color COLOR_CONTRAST_BACKGROUND = Colors.white;
const Color COLOR_FLOATING_TEXT = Colors.white;
const Color COLOR_CONFINED_TEXT = Colors.black;
const Color COLOR_FLOATING_LINK_TEXT = Colors.yellow;

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        title: const Text('$APP_NAME. Logged in'),
      ),
      body: ElevatedButton (
        child: Text('Log out'),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          // Now navigate to the auth page.
          Navigator.pushReplacement(
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
