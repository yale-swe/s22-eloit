import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eloit/services/database.dart';

Future<bool> SignInFunc(_email, _password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password);
    return true;
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
