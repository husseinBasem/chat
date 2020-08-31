import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chat/Component/rounded_button.dart';
import 'package:chat/constans.dart';

class RegistrationScreen extends StatefulWidget{

  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(height: 48.0,),
            TextField(
              onChanged: (value) {

              },
              decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Email'),
            ),
            SizedBox(height: 8.0,),

            TextField(
              onChanged: (value) {

              },
              decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Password'),
            ),
            SizedBox(height: 24.0,),
            RoundedButton(
                onPressed: (){},
              color: Colors.blueAccent,
              text: 'Register',
            ),


          ],
        ),
      ),

    );
  }
}