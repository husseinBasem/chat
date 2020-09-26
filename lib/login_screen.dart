import 'package:chat/constans.dart';
import 'package:flutter/material.dart';
import 'package:chat/Component/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  String _email, _password, _errorEmail, _errorPassword;
  final _auth = FirebaseAuth.instance;

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
                  height: 48.0,
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
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (value) {
                      _password = value;
                      _errorPassword = null;
                    },
                    decoration: KTextFieldDecoration.copyWith(
                        hintText: 'Enter Your Password',
                        errorText: _errorPassword)),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  onPressed: login,
                  text: 'Log In',
                  color: Colors.lightBlueAccent,
                ),
                SizedBox(
                  height: 24.0,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'registration_screen');
                  },
                  child: Text('Switch to Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (user != null) {
        Navigator.pushNamed(context, 'chat_list');
      }
    } catch (e) {
      if (e.toString().contains('invalid-email')) {
        _errorEmail = 'The Email Address is Not Valid';
        setState(() {
          showSpinner = false;
        });
        return;
      } else if (e.toString().contains('user-not-found')) {
        _errorEmail = 'There is No User Corresponding to The Given Email';
        setState(() {
          showSpinner = false;
        });
        return;
      } else if (e.toString().contains('wrong-password')) {
        _errorPassword = 'The Password is Invalid For The Given Email';
        setState(() {
          showSpinner = false;
        });
        return;
      } else {
        print(e.toString());
      }
    }

    setState(() {
      showSpinner = false;
    });
  }
}
