import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chat/Component/rounded_button.dart';
import 'package:chat/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String _email,
      _password,
      _name,
      _userName,
      _errorEmail,
      _errorPassword,
      _errorUser;
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
            padding: EdgeInsets.all(10.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  height: 24.0,
                ),
                Container(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    _email = value;
                    _errorEmail = null;
                  },
                  decoration: KTextFieldDecoration.copyWith(
                      hintText: 'Enter Your Email', errorText: _errorEmail),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) => _name = value,
                  decoration: KTextFieldDecoration.copyWith(
                      hintText: 'Enter Your Name'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    _password = value;
                    _errorPassword = null;
                  },
                  decoration: KTextFieldDecoration.copyWith(
                      hintText: 'Enter Your Password',
                      errorText: _errorPassword),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    _userName = value;
                    _errorUser = null;
                  },
                  decoration: KTextFieldDecoration.copyWith(
                      hintText: 'Enter Your User', errorText: _errorUser),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  onPressed: addUser,
                  color: Colors.blueAccent,
                  text: 'Register',
                ),
                SizedBox(
                  height: 24.0,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                  child: Text('Switch to Login IN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> usernameCheck(String username) async {
    final result = await _fireStore
        .collection('users')
        .where('User', isEqualTo: username)
        .get();

    return result.docs.isEmpty;
  }

  Future<void> addUser() async {
    setState(() {
      showSpinner = true;
    });

    try {
      final valid = await usernameCheck(_userName);
      if (!valid) {
        _errorUser = 'This User is Already exists';

        setState(() {
          showSpinner = false;
        });
        return;
      }

      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email.trim(), password: _password.trim());
      _fireStore
          .collection('users').doc(newUser.user.uid)
          .set({
            'Name': _name.trim(),
            'User': _userName.trim(),
            'Uid': newUser.user.uid,
            'Email' : _email.trim(),
            'userImage' : '',
          })
          .catchError((error) => print("Failed to add user: $error"));

      if (newUser != null) {
        Navigator.pushNamed(context, 'chat_list');
      }
    } catch (e) {
      print(e.toString());
      if (e.toString().contains('email-already-in-use')) {
        _errorEmail = 'Email Aleady In use';
        setState(() {
          showSpinner = false;
        });
        return;
      } else if (e.toString().contains('invalid-email')) {
        _errorEmail = 'Please Use Correct Email';
        setState(() {
          showSpinner = false;
        });
        return;
      } else if (e.toString().contains('Given String is empty')) {
        _errorEmail = 'can\'t leave this field empty';
        setState(() {
          showSpinner = false;
        });
        return;
      } else if (e.toString().contains('weak-password')) {
        _errorPassword = 'Please Write at Least 6 characters';
        setState(() {
          showSpinner = false;
        });
        return;
      } else
        print(e.toString());
    }

    setState(() {
      showSpinner = false;
    });
  }
}
