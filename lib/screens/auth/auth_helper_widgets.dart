import 'package:eloit/screens/home.dart';
import 'package:eloit/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Some custom widgets to make this easier...
// 0. First setup an abstract widget for all text form fields.
class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.controller,
    required this.validator,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  final String? Function(String?) validator;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // style: const TextStyle(
      //   color: COLOR_FLOATING_TEXT,
      // ),
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          // borderSide: BorderSide(
          //   color: COLOR_CONTRAST_BACKGROUND,
          // ),
        ),
        // hintStyle: const TextStyle(
        //   color: Color.fromARGB(255, 189, 167, 167),
        // ),
        hintText: hintText,
      ),
    );
  }
}

// 1. Email Field
class EmailField extends StatelessWidget {
  const EmailField({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      controller: controller,
      validator: inspectEmail,
      hintText: 'Email',
    );
  }
}

// 2. Field for passord during signin
class SignInPasswordField extends StatelessWidget {
  const SignInPasswordField({Key? key, required this.controller})
      : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      validator: inspectSigninPassword,
      controller: controller,
      hintText: 'Password',
      obscureText: true,
    );
  }
}

// 3. Field for password during registering
class RegisterPasswordField extends StatelessWidget {
  const RegisterPasswordField({Key? key, required this.controller})
      : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      validator: inspectRegisterPassword,
      controller: controller,
      obscureText: true,
      hintText: 'Password',
    );
  }
}

// 4. Text field for password confirmation.
class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({
    Key? key,
    required this.passwordController,
    required this.confirmationController,
  }) : super(key: key);

  final TextEditingController passwordController;
  final TextEditingController confirmationController;

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      validator: (String? givenText) => givenText == passwordController.text
          ? null
          : 'Passwords do not match.',
      controller: confirmationController,
      obscureText: true,
      hintText: 'Re-type password',
    );
  }
}

// 5. Padding between textfields and buttons
class FormPaddingLayer extends StatelessWidget {
  const FormPaddingLayer({Key? key}) : super(key: key);
  final paddingAspectRatio = 20;

  @override
  Widget build(BuildContext context) {
    double paddingWidth = MediaQuery.of(context).size.width;
    double paddingHeight = paddingWidth / paddingAspectRatio;
    return SizedBox(
      width: paddingWidth,
      height: paddingHeight,
    );
  }
}

// Helper functions for authentication
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
  if (formPassword.length < 6) {
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

    return 'Must include alphabetical character, number, and one of @#\\\$%^&)(-+=';
  }

  return null;
}
