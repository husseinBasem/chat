import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_list.dart';
import 'login_screen.dart';
import '../Transition/fade_transition.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.pushAndRemoveUntil(context, FadeRoute(page: getWidget()), (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,


      child: Container(

        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset('images/1721.png'),
            radius: 150.0,

          ),
        ),
      ),
    );
  }

  Widget getWidget() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return ChatList();
      }
      else
        return LoginScreen();
    } catch (e) {
      print(e);
      return null;
    }
  }



}


