import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:eloit/screens/auth/registration.dart';
import 'package:eloit/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  Future<bool> trySessionLogin() async {
    bool sessionFound = await RecoverSession();
    if (sessionFound) {
      User? _user = FirebaseAuth.instance.currentUser;
      // If there is still no user, return the authentication widget
      if (_user != null) {
        print("Session login successful");
        return true;
      }
    }

    // In case something above doesn't work, return the authentication page
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // This is just to double check that the _user should not be null if the stream fetches data.
    User? _user = FirebaseAuth.instance.currentUser;

    // If _user is null, see if there is a user saved in session.
    if (_user != null) {
      return ConfirmEmailPage();
    } else {
      return FutureBuilder<bool>(
          future: trySessionLogin(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data ?? false) {
                return ConfirmEmailPage();
              } else {
                return AuthBox();
              }
            }

            // If snapshot doesn't return anything, just have a status indicator
            return const LinearProgressIndicator();
          });
    }
  }
}
