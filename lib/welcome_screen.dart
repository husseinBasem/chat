import 'package:flutter/material.dart';
import 'package:chat/Component/rounded_button.dart';


class WelcomeScreen extends StatefulWidget{
  @override
  _WelcomeScreenState createState() =>
    _WelcomeScreenState();



}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{


  AnimationController Controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    Controller = AnimationController(

        vsync: this,
        duration: Duration(seconds: 1),

    );

    animation = ColorTween(begin: Colors.grey,end: Colors.white).animate(Controller);
    Controller.forward();
    Controller.addListener(() {
      setState(() {});

    });
  }

  @override
  void dispose() {
    Controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                 Hero(
                   tag: 'logo',
                   child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                 ),

                Text('Flash Chat', style: TextStyle(fontSize: 45.0,fontWeight: FontWeight.w900,color: Colors.black),),
                ]
            ),
                SizedBox(height: 48.0,),
                RoundedButton(
                  onPressed: (){Navigator.pushNamed(context, 'login_screen');} ,
                  color: Colors.lightBlueAccent,
                  text: 'Log In',
                ),
                RoundedButton(
                    onPressed: (){Navigator.pushNamed(context, 'registration_screen');},
                  text: 'Register',
                  color: Colors.blueAccent,
                ),


          ],
        ),
      ),
    );
  }


}
