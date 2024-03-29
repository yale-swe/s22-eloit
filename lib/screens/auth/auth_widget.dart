import 'dart:async';
import 'dart:math';

import 'package:eloit/screens/auth/registration.dart';
import 'package:eloit/screens/wrapper.dart';
import 'package:eloit/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import 'auth_helper_widgets.dart';

// This defines the 2 initial authentication pages.
enum AuthPage {
  signInPage,
  registerEmailPage,
}

class AuthBox extends StatefulWidget {
  const AuthBox({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthBox> createState() => _AuthBoxState();
}

class _AuthBoxState extends State<AuthBox> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // TODO: Only come to this widget if there is no user signed in.
  var currentState = AuthPage.signInPage;

  // This is for form validation
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // If you're on a wide screen, make the width short.
    double scaleFactor = 1.5;
    if (width > height) {
      width = height / scaleFactor;
    }

    void toggleSigninSignup() => setState(() {
          if (currentState == AuthPage.signInPage) {
            currentState = AuthPage.registerEmailPage;
          } else if (currentState == AuthPage.registerEmailPage) {
            currentState = AuthPage.signInPage;
          }
        });

    switch (currentState) {
      case AuthPage.signInPage:
        // TODO: maybe place the common widgets outside
        return Scaffold(
          appBar: AppBar(title: const Text(APP_NAME)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              // TODO: See what the line below would do
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _key,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const FormPaddingLayer(),
                  EmailField(controller: emailController),
                  const FormPaddingLayer(),
                  SignInPasswordField(controller: passwordController),
                  const FormPaddingLayer(),
                  SizedBox(
                    width: width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          bool readyToSignIn = await SignInFunc(
                              emailController.text.trim(),
                              passwordController.text.trim());
                          if (readyToSignIn) {
                            // REDIRECT to home
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Wrapper()));
                          } else {
                            // TODO: Show this message on the app
                            print('Login failed! SignInFunc returned false');
                          }
                        }
                      },
                      child: Text('Sign in'),
                    ),
                  ),
                  const FormPaddingLayer(),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline6?.color,
                        ),
                        text: 'New to $APP_NAME? ',
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = toggleSigninSignup,
                            text: 'Sign up.',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        );

      case AuthPage.registerEmailPage:
        return Scaffold(
          appBar: AppBar(title: const Text(APP_NAME)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              child: Form(
                // TODO: See what the line below would do
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const FormPaddingLayer(),
                    EmailField(controller: emailController),
                    const FormPaddingLayer(),
                    SizedBox(
                      width: width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            // TODO: Send a request to check if the email exists.
                            // TODO: Send some verification code to that email,
                            // TODO: Set up page for receiving verification code.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationBox(
                                  email: emailController.text.trim(),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Continue'),
                      ),
                    ),
                    const FormPaddingLayer(),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline6?.color,
                          ),
                          text: 'Already have an account? ',
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = toggleSigninSignup,
                              text: 'Log in.',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }
}
