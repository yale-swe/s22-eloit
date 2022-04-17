import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:eloit/screens/auth/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is just to double check that the _user should not be null if the stream fetches data.
    User? _user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: StreamBuilder<User?>(builder: (context, snapshot) {
        if (snapshot.hasData) {
          assert(_user != null);
          return ConfirmEmailPage();
        } else {
          return AuthBox();
        }
      }),
    );
  }
}
