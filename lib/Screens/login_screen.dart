import 'package:chat/Transition/fade_transition.dart';
import 'package:chat/Transition/slide_right_route.dart';
import 'package:chat/Screens/registration_screen.dart';
import 'package:chat/bloc/Login_bloc/login_bloc.dart';
import 'package:chat/constans.dart';
import 'package:flutter/material.dart';
import 'package:chat/Component/rounded_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'chat_list.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
     {
  String _email, _password;
  LoginBloc bloc;

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {


    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),

      child: Container(
        decoration: BoxDecoration(
          image:DecorationImage(
              image: AssetImage('images/guftuc4o9ik41.jpg'),
            fit: BoxFit.cover,

          ) ,


        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,

          body: SafeArea(
            child: BlocListener<LoginBloc, LoginStates>(
              cubit:bloc ,
              listener: (context, state) {
                if (state is LoggedInState) {
                  Navigator.pushAndRemoveUntil(context, FadeRoute(page: ChatList()),(Route<dynamic> route) => false);
                }

              },
              child: BlocBuilder<LoginBloc, LoginStates>(
                  cubit: bloc,
                  builder: (context, state) {
                    bloc = BlocProvider.of<LoginBloc>(context);




                    return ModalProgressHUD(
                      inAsyncCall: bloc.spinner,
                      opacity: 0.07,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: double.infinity,
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
                                    child: Image.asset('images/1721.png'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 48.0,
                              ),
                              TextField(
                                autofocus: false,
                                style: TextStyle(color: Colors.white) ,
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  _email = value;
                                  if (bloc.errorEmail != null) {
                                    bloc.add(ChangeInputEmailEvent());
                                  }
                                },
                                decoration: KTextFieldDecoration.copyWith(
                                    hintText: 'Enter Your Email',
                                    errorText: bloc.errorEmail),

                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.center,
                                  obscureText: true,
                                  onChanged: (value) {
                                    _password = value;
                                    if (bloc.errorPassword != null) {
                                      bloc.add(ChangeInputPasswordEvent());
                                    }
                                  },
                                  decoration: KTextFieldDecoration.copyWith(
                                      hintText: 'Enter Your Password',
                                      errorText: bloc.errorPassword)
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              RoundedButton(
                                onPressed: (){
                                  bloc.add(LoginEvent(email: _email, password: _password));
                                  },
                                text: 'Log In',
                                color: Colors.blueAccent,

                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(context, SlideRightRoute(page: RegistrationScreen(),dx: 1.0,dy: 0.0));

                                },
                                child: Text('Switch to Register',style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }


}
