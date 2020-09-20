import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chat/Component/rounded_button.dart';
import 'package:chat/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class RegistrationScreen extends StatefulWidget{

  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {


  bool showSpinner = false;
  String _Email,_Password,_FirstName,_LastName,_UserName;
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            shrinkWrap: true,

            children: <Widget>[

              Container(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(height: 48.0,),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {

                  _Email = value;

                },
                decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Email'),
              ),
              SizedBox(height: 8.0,),

              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  _Password = value;

                },
                decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Password'),
              ),
              SizedBox(height: 8.0,),

              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _FirstName = value;

                },
                decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your First Name'),
              ),
              SizedBox(height: 8.0,),

              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _LastName = value;

                },
                decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Last Name'),
              ),
              SizedBox(height: 8.0,),

              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _UserName = value;

                },
                decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your User'),
              ),
              SizedBox(height: 24.0,),
              RoundedButton(
                  onPressed: () async{

                    setState(() {
                      showSpinner = true;
                    });

                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: _Email, password: _Password);
                      _fireStore.collection('users').add({
                        'firstName': _FirstName,
                        'lastName':  _LastName,
                        'user': _UserName,
                        'uid': newUser.user.uid
                      }
                          ).catchError((error)=> print("Failed to add user: $error"));

                      if (newUser != null) {
                        Navigator.pushNamed(context, 'chat_screen');
                      }
                    }catch(e){
                      print(e.toString());
                    }

                    setState(() {
                      showSpinner = false;
                    });

                  },
                color: Colors.blueAccent,
                text: 'Register',
              ),




            ],
          ),
        ),
      ),

    );
  }
}