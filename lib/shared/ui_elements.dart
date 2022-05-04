import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:eloit/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

PreferredSizeWidget createCustomAppBar(BuildContext context,
    [String? title = APP_NAME, double insetRatio = 0.009]) {
  String barTitle = title ?? APP_NAME;
  double barInsetRatio = insetRatio == 0.0 ? 0.009 : insetRatio;
  double edgeInset = MediaQuery.of(context).size.width * barInsetRatio;

  return AppBar(
    title: Text(barTitle),
  );
}
