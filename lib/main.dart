import 'package:chat/Screens/registration_screen.dart';
import 'package:chat/splash_screen.dart';
import 'package:chat/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/chat_list.dart';
import 'Screens/chat_screen.dart';
import 'Screens/info_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/edit_screen.dart';
import 'Screens/search_screen.dart';

void main()async  {
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
      home: SplashScreen(),

//      initialRoute: 'splash_screen',
//      routes: {
//        'welcome_screen': (context)=> WelcomeScreen(),
//        'chat_screen' : (context)=> ChatScreen(),
//        'login_screen' : (context)=> LoginScreen(),
//        'registration_screen' : (context) => RegistrationScreen(),
//        'chat_list' : (context) => ChatList(),
//        'search_screen': (context) => SearchScreen(),
//        'edit_screen':(context) => Edit(),
//        'splash_screen':(context) => SplashScreenn(),
//
//      },
      debugShowCheckedModeBanner: false,
    );
  }
}
