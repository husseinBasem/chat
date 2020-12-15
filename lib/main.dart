import 'package:chat/Screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(Chat());
}

class Chat extends StatefulWidget {

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);


  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached ) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.email)
          .update({
        'chattingWith': null,
      });
    }


  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      home: SplashScreen(),

      debugShowCheckedModeBanner: false,
    );
  }
}
