import 'package:firebase_auth/firebase_auth.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

Future<bool> SignInFunc(_email, _password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password);
  } catch (e) {
    print("SignInWithEmailAndPassword Failed. Returned this:");
    print(e.toString());
    return false;
  }

  try {
    // Save a sign in token in a session (used for web)
    await SessionManager()
        .set('token', await FirebaseAuth.instance.currentUser?.getIdToken());
  } catch (e) {
    print("Saving session failed for this reason:");
    print(e.toString());
  }
  return true;
}

Future<bool> RecoverSession() async {
  try {
    String? savedToken = await SessionManager().get('token');
    if (savedToken != null && savedToken != '') {
      await FirebaseAuth.instance.signInWithCustomToken(savedToken);
      return true;
    } else {
      print("Login with session failed");
      return false;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> RegisterFunc(email, password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      DatabaseService().addUser(value.user?.uid, value.user?.email);
    });
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print("The password provided is too weak.");
    } else if (e.code == 'email-already-in-use') {
      print("The email provided is already in use.");
    }
  } catch (e) {
    print("\n\nDEBUG: Registraion failed b/c of the error below\n");
    print(e.toString());
  }

  // You should end up here if the try case fails
  return false;
}
