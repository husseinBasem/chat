import 'package:chat/bloc/register_bloc/events.dart';
import 'package:chat/bloc/register_bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chat/Component/rounded_button.dart';
import 'package:chat/constans.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../bloc/register_bloc/bloc.dart';

class RegistrationScreen extends StatefulWidget {
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _email, _password, _name, _userName;

  RegisterBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocListener(
            cubit: bloc,
            listener: (context, state) {
              bloc = BlocProvider.of<RegisterBloc>(context);

              if (state is RegisteredState) {
                Navigator.pushNamed(context, 'chat_list');
              }
              if (state is SwitchToLoginState){
                Navigator.pushNamed(context, 'login_screen');
              }
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
                cubit: bloc,
                builder: (context, state) {
                  bloc = BlocProvider.of<RegisterBloc>(context);



                  return ModalProgressHUD(
                    inAsyncCall: bloc.showSpinner,
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
                                submitRegister();
                              },
                              color: Colors.blueAccent,
                              text: 'Register',
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            FlatButton(
                              onPressed: () {
                                bloc.add(SwitchToLoginEvent());
                              },
                              child: Text('Switch to Login IN'),
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
    );
  }

  void submitRegister() {
    bloc.add(SpinnerOnEvent());
    bloc.add(AddUserEvent(_userName, _email, _password, _name));
    bloc.add(SpinnerOffEvent());
    bloc.add(RegisteredEvent());
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }
}
