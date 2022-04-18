import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  
  // Create an instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // // Sing in anonymously
  // Future SignInAnonymously() async {
  //   try {
  //     UserCredential result = await _auth.signInAnonymously();
  //     final User? _user = result.user;
  //   } 
  //   catch(e) {

  //   }
  // }

  // TODO: Register with email, password

  // TODO: Sign in with email, password

  // TODO: Sign in
}


Future<bool> SignInFunc (_email, _password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _email, password: _password
    );
    return true;
  }
  catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> RegisterFunc(email, password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
    ).then((value) {FirebaseFirestore.instance.collection("users").doc(value.user?.uid).set({"email": value.user?.email});});
    return true;
  }
  on FirebaseAuthException catch(e) {
    if (e.code == 'weak-password') {
      print("The password provided is too weak.");
    }
    else if (e.code == 'email-already-in-use') {
      print("The email provided is already in use.");
    }
  }
  catch (e) {
    print(e.toString());
  }

  // You should end up here if the try case fails
  return false;
}
