import 'dart:math';

import 'package:flutter/material.dart';

class AuthBox extends StatefulWidget {
  const AuthBox({ Key? key }) : super(key: key);

  @override
  State<AuthBox> createState() => _AuthBoxState();
}

void SubmitButtonFunc () {
  // TODO: Write this out
}

class _AuthBoxState extends State<AuthBox> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double side = min(width, height);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eloit')
      ),
      body: SizedBox(
        width: side,
        height: side,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            Padding (
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextButton(
                onPressed: SubmitButtonFunc,
                child: Text('Continue'),
              )
            )
          ]
        ),
      ),
    );
  }
}