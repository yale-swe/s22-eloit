import 'dart:async';
import 'dart:math';

import 'package:eloit/screens/wrapper.dart';
import 'package:eloit/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import 'auth_helper_widgets.dart';

// TODO: Turn this page into state machine for getting username too
enum ConfirmationPage {
  registerPasswordPage,
  createUserNamePage,
}

class RegistrationBox extends StatefulWidget {
  const RegistrationBox({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  State<RegistrationBox> createState() => _RegistrationBoxState();
}

class _RegistrationBoxState extends State<RegistrationBox> {
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

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

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(title: const Text(APP_NAME)),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Form(
            // TODO: See what the line below would do
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const FormPaddingLayer(),
                const Text(
                  'Create a password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const FormPaddingLayer(),
                RegisterPasswordField(controller: passwordController),
                const FormPaddingLayer(),
                ConfirmPasswordField(
                    passwordController: passwordController,
                    confirmationController: confirmPasswordController),
                const FormPaddingLayer(),
                SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        // TODO: Confirm the password from backend first
                        // Now add the user with email and password
                        bool registerAndLogIn = await RegisterFunc(
                          widget.email,
                          passwordController.text,
                        );
                        if (registerAndLogIn) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmEmailPage(),
                            ),
                          );
                        } else {
                          // TODO: Check what might cause this.
                          print('Registration failed');
                        }
                      }
                    },
                    child: const Text('Confirm Password'),
                  ),
                ),
                const FormPaddingLayer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmEmailPage extends StatefulWidget {
  const ConfirmEmailPage({Key? key}) : super(key: key);

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  late User user;
  int resendCount = 0;

  @override
  void initState() {
    super.initState();

    // Check if the email has been verified
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  Future sendVerificationEmail() async {
    try {
      user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    user = FirebaseAuth.instance.currentUser!;
    // Reload the user
    await user.reload();

    if (user.emailVerified) {
      timer?.cancel();
      setState(() {
        isEmailVerified = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: print the email to which the verification was sent.
    String bodyContent = resendCount == 0
        ? "A verification link has been sent. Go and click it."
        : "Resent verification link, now $resendCount times.";

    // If you're on a wide screen, make the width short.
    double scaleFactor = 1.5;
    if (width > height) {
      width = height / scaleFactor;
    }

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(title: const Text(APP_NAME)),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const FormPaddingLayer(),
              Text(bodyContent),
              const FormPaddingLayer(),
              RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: COLOR_FLOATING_TEXT,
                    ),
                    text: "Can't find link? ",
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          // Call the send code function here.
                          ..onTap = () {
                            user.sendEmailVerification();
                            setState(() {
                              resendCount++;
                            });
                          },
                        text: 'Resend.',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: COLOR_FLOATING_LINK_TEXT,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
