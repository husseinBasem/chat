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
  String _Email,_Password,_Name,_UserName,_errorEmail,_errorPassword,_errorName,_errorUser;
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(

        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 24.0),
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

                  decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Email',errorText:_errorEmail),
                ),
                SizedBox(height: 8.0,),



                TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    _Name = value;

                  },
                  decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Name'),
                ),
                SizedBox(height: 8.0,),

                TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    _Password = value;

                  },
                  decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Password',errorText: _errorPassword),
                ),
                SizedBox(height: 8.0,),



                TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    _UserName = value;
                  },

                  decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your User',errorText: _errorUser),
                ),
                SizedBox(height: 24.0,),
                RoundedButton(
                    onPressed: () async{



                      setState(() {
                        showSpinner = true;
                      });

                      try {
                       // _errorUser= '';

                        _fireStore.collection('users').get().then((QuerySnapshot snapshot) {
                          snapshot.docs.forEach((existsUser) {
                            if (_UserName == existsUser.data()['User']){

                              _errorUser = 'The User Already Exists';
                              setState(() {
                                showSpinner = false;
                              });

                              return;
                            }
                          });

                        });

                        final newUser = await _auth.createUserWithEmailAndPassword(
                            email: _Email, password: _Password);
                        _fireStore.collection('users').add({
                          'Name': _Name.trim(),
                          'User': _UserName.trim(),
                          'Uid': newUser.user.uid
                        }
                            ).catchError((error)=> print("Failed to add user: $error"));

                        if (newUser != null || _errorUser.isEmpty == false) {
                          Navigator.pushNamed(context, 'chat_screen');
                        }
                      }
                      catch(e){
                        print(e.toString());
                        if(e.toString().contains('email-already-in-use')){
                          _errorEmail = 'Email Aleady In use';
                          setState(() {
                            showSpinner = false;
                          });
                          return;
                        }
                        if(e.toString().contains('invalid-email')){
                          _errorEmail = 'Please Use Correct Email';
                          setState(() {
                            showSpinner = false;
                          });
                          return;
                        }
                        if (e.toString().contains('Given String is empty')){
                          _errorEmail = 'can\'t leave this field empty' ;
                          setState(() {
                            showSpinner = false;
                          });
                          return;

                        }
                        if (e.toString().contains('weak-password')){
                          _errorPassword ='Please Write at Least 6 characters';
                          setState(() {
                            showSpinner = false;
                          });
                          return;

                        }





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
      ),

    );
  }



}