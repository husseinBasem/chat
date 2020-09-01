
import 'package:chat/constans.dart';
import 'package:flutter/material.dart';
import 'package:chat/Component/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginSceen extends StatefulWidget{

  @override
  _LoginScreenState  createState()=> _LoginScreenState();
}

class _LoginScreenState extends State<LoginSceen> with SingleTickerProviderStateMixin{


  bool showSpinner = false;
  String _Email,_Password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0,),
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

              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,


                onChanged: (value){

                  _Email = value;

                },
                decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Email'),

              ),

              SizedBox(height: 8.0,),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value){

                  _Password = value;

                },
                decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Password')

              ),
              SizedBox(height: 24.0,),
              RoundedButton(
                  onPressed: () async{

                    setState(() {
                      showSpinner = true;
                    });


                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: _Email, password: _Password);
                      if (user != null) {
                        Navigator.pushNamed(context, 'chat_screen');
                      }
                    }catch(e){
                      print(e.toString());
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  },
                text: 'Log In',
                color: Colors.lightBlueAccent,
              ),



            ],
          ),
        ),
      ),


    );
  }

}