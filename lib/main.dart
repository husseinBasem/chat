import 'package:chat/registration_screen.dart';
import 'package:chat/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Chat());
}

class Chat extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
//      home: RegistrationScreen(),

      initialRoute: 'registration_screen',
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
