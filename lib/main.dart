import 'package:chat/registration_screen.dart';
import 'package:chat/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chat_list.dart';
import 'chat_screen.dart';
import 'info_screen.dart';
import 'login_screen.dart';
import 'search_screen.dart';

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
//      home: Info(),

      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context)=> WelcomeScreen(),
        'chat_screen' : (context)=> ChatScreen(),
        'login_screen' : (context)=> LoginScreen(),
        'registration_screen' : (context) => RegistrationScreen(),
        'chat_list' : (context) => ChatList(),
        'search_screen': (context) => SearchScreen(),
        'info_screen': (context) => Info(),

      },
      debugShowCheckedModeBanner: false,
    );
  }
}
