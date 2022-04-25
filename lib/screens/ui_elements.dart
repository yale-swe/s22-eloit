import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:eloit/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget createCustomAppBar(BuildContext context,
    [String? title = APP_NAME, double insetRatio = 0.009]) {
  String barTitle = title ?? APP_NAME;
  double barInsetRatio = insetRatio == 0.0 ? 0.009 : insetRatio;
  double edgeInset = MediaQuery.of(context).size.width * barInsetRatio;

  return AppBar(
    title: Text(barTitle),
    actions: [
      TextButton(
        child: Padding(
          padding: EdgeInsets.all(edgeInset),
          child: Text(
            'Log Out',
            style: TextStyle(
                color: Theme.of(context).primaryTextTheme.button?.color),
          ),
        ),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          // Now navigate to the auth page.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthBox(),
            ),
          );
        },
      ),
    ],
  );
}
