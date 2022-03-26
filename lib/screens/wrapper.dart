import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:eloit/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Return Home if the user is signed in.
    // _user is null if no one is logged in
    User? _user = FirebaseAuth.instance.currentUser;

    // Return Authentication page if user is not logged in.
    if (_user == null) {
      return AuthBox();
    }
    // But if logged in, return the Home page
    else {
      return Home();
    }
  }
}
