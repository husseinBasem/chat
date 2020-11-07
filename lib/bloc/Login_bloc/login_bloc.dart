import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  LoginBloc() : super(LoginInitial());

  bool spinner = false, somethingWrong = false;
  String errorEmail, errorPassword;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  Stream<LoginStates> mapEventToState(
    LoginEvents event,
  ) async* {
    if (event is SpinnerOnEvent) {
      yield SpinnerOnState(spinner: spinner = true);
    }

    if (event is SpinnerOffEvent) {
      yield SpinnerOffState(spinner: spinner = false);
    }

    if (event is ChangeInputEmailEvent) {
      yield ChangeInputEmailState(email: errorEmail = null);
    }
    if (event is ChangeInputPasswordEvent) {
      yield ChangeInputPasswordState(password: errorPassword = null);
    }

    if (event is LoggedInEvent &&
        errorEmail == null &&
        errorPassword == null &&
        somethingWrong == false) {
      yield LoggedInState();
    }

    if (event is LoginEvent) {
      await login(event.email, event.password);
      await updateToken(event.email);
      yield LoginState();
    }


  }

  Future<void> login(String _email, _password) async {
    final _auth = FirebaseAuth.instance;

    try {
      await _auth.signInWithEmailAndPassword(
          email: _email.trim(), password: _password.trim());
    } catch (e) {
      if (e.toString().contains('invalid-email')) {
        errorEmail = 'The Email Address is Not Valid';
      } else if (e.toString().contains('user-not-found')) {
        errorEmail = 'There is No User Corresponding to The Given Email';
      } else if (e.toString().contains('wrong-password')) {
        errorPassword = 'The Password is Invalid For The Given Email';
      } else if (e.toString().contains('String is empty')) {
        errorPassword = 'Given String is empty or null';
      } else {
        somethingWrong = true;
      }
    }
  }

  Future<void> updateToken(String _email)async {
   await FirebaseFirestore.instance.collection('users').doc(_email).update({
     'mobileToken': await _firebaseMessaging.getToken(),

   });

  }
}
