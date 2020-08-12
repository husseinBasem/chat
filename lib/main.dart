import 'package:flutter/material.dart';

void main() {
  runApp(Chat());
}

class Chat extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black45)
        )
      ),
      home: Chat(),
    );
  }
}
