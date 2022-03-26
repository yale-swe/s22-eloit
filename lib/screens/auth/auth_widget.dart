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
        height: side/1.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
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
                  )
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}