import 'package:chat/registration_screen.dart';
import 'package:chat/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'login_screen.dart';

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
          bodyText1: TextStyle(color: Colors.black45)
        )
      ),
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context)=> WelcomeScreen(),
        'chat_screen' : (context)=> ChatScreen(),
        'login_screen' : (context)=> LoginSceen(),
        'registration_screen' : (context) => RegistrationScreen(),

      },
      debugShowCheckedModeBanner: false,
    );
  }
}
