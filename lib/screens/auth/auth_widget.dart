import 'dart:math';

import 'package:eloit/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home.dart';


class AuthBox extends StatefulWidget {
  const AuthBox({ Key? key }) : super(key: key);

  @override
  State<AuthBox> createState() => _AuthBoxState();
}

class _AuthBoxState extends State<AuthBox> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // This is for form validation
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double side = min(width, height);
    
    // TODO: Use setState(() {}) to improve the authentication page.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eloit')
      ),
      body: SizedBox(
        width: side,
        height: side/1.2,
        child: Form(
          // TODO: See what the line below would do
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  validator: inspectEmail,
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
              ),
              Padding (
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  validator: inspectSigninPassword,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
              ),
              Row (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextButton(
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          bool readyToSignIn = await SignInFunc(
                            emailController.text, passwordController.text
                            );
                          if (readyToSignIn) {
                            // REDIRECT to home
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => Home())
                            );
                          }
                          else {
                            // STAY here
                            print('Login failed!');
                          }
                        }
                      },
                      child: Text('Continue'),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextButton(
                      onPressed: () async {
                        bool registerAndLogIn = await RegisterFunc(
                          emailController.text, passwordController.text
                        );
                        if (registerAndLogIn) {
                          // Redirect to home
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => Home())
                          );
                        }
                        else {
                          // Stay here
                          print('Registration failed!');
                        }
                      },
                      child: Text('Register'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


String? inspectEmail(String? formEmail) {
  // First check that the email field is not empty
  if (formEmail == null || formEmail.isEmpty) {
    return 'I need an email address here.';
  }

  // Then check if the email looks valid
  String pattern = r'^.{1,}@.{1,}\..{1,}$';
  RegExp regEx = RegExp(pattern);
  if (!regEx.hasMatch(formEmail)) {
    return "Email doesn't look valid";
  }

  // The email looks valid. Return null
  return null;
}

String? inspectSigninPassword(String? formPassword) {
  // First check that the password field is not empty
  if (formPassword == null || formPassword.isEmpty) {
    return 'I need your password pls.';
  }

  // Then check if the given password has the right number of characters...
  if (formPassword.length < 6){
    return 'Password needs to be at least 6 characters.';
  }
  if (formPassword.length > 20) {
    return 'Password length cannot exceed 20 characters';
  }

  return null;
}

String? inspectRegisterPassword(String? formPassword) {
  // First check that the password field is not empty
  if (formPassword == null || formPassword.isEmpty) {
    return 'Pls insert a password';
  }

  // Define the requirements for a password.
  String rPattern = '^.[0-9a-zA-Z@#\\\$%^&-+=()]{6,20}\$';  
  RegExp regex = RegExp(rPattern);

  // If the
  if (!regex.hasMatch(formPassword)) {
    if (formPassword.length < 6 || formPassword.length > 20) {
      return 'This must be between 6 and 20 characters long.';
    }

    return 'Only use alphabets, numbers or one of @#\\\$%^&)(-+=';
  }

  return null;
}
