import 'package:eloit/screens/auth/authenticate.dart';
import 'package:eloit/screens/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Return Home if the user is signed in.
    // Else return Auth
    return AuthBox();
  }
}
