import 'package:chat/Transition/fade_transition.dart';
import 'package:chat/bloc/register_bloc/events.dart';
import 'package:chat/bloc/register_bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chat/Component/rounded_button.dart';
import 'package:chat/constans.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../bloc/register_bloc/bloc.dart';
import 'chat_list.dart';

class RegistrationScreen extends StatefulWidget {
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _email, _password, _name, _userName;

  RegisterBloc bloc;


  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/guftuc4o9ik41.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BlocListener(
              cubit: bloc,
              listener: (context, state) {

                if (state is RegisteredState) {
                  Navigator.pushAndRemoveUntil(context, FadeRoute(page: ChatList()),(Route<dynamic> route) => false);
                }

              },
              child: BlocBuilder<RegisterBloc, RegisterState>(
                  cubit: bloc,
                  builder: (context, state) {
                    bloc = BlocProvider.of<RegisterBloc>(context);



                    return ModalProgressHUD(
                      inAsyncCall: bloc.showSpinner,
                      opacity: 0.07,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: double.infinity,
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
                                    child: Image.asset('images/1721.png'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 48.0,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  _email = value;
                                  if (bloc.email != null) {
                                    bloc.add(ChangeInputEmailEvent());
                                  }
                                },
                                decoration: KTextFieldDecoration.copyWith(
                                  hintText: 'Enter Your Email',
                                  errorText: bloc.email,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.white),
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
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.center,
                                obscureText: true,
                                onChanged: (value) {
                                  _password = value;
                                  if (bloc.password != null) {
                                    bloc.add(ChangeInputPasswordEvent());
                                  }
                                },
                                decoration: KTextFieldDecoration.copyWith(
                                  hintText: 'Enter Your Password',
                                  errorText: bloc.password,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  _userName = value;
                                  if (bloc.userName == null) {
                                    bloc.add(CheckUserEvent(userName: value));
                                  } else {
                                    bloc.add(
                                        SecondCheckUserEvent());
                                  }
                                },
                                decoration: KTextFieldDecoration.copyWith(
                                    hintText: 'Enter Your User',
                                    errorText: bloc.userName),
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              RoundedButton(
                                onPressed: () {
                                  bloc.add(AddUserEvent(_userName, _email, _password, _name));

                                },
                                color: Colors.blueAccent,
                                text: 'Register',
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                },
                                child: Text('Switch to Login',style: TextStyle(color: Colors.white),),
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


