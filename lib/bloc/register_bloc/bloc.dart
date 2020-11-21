import 'package:chat/bloc/register_bloc/events.dart';
import 'package:chat/bloc/register_bloc/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent,RegisterState>{
  RegisterBloc() : super(InitialState());



String email,password,userName;
bool showSpinner=false;
bool somethingWrong=false;

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {

    if (event is SpinnerOnEvent){
      yield SpinnerOnState(spinner: showSpinner =true);

    }

    if (event is SpinnerOffEvent){
      yield SpinnerOffState(spinner: showSpinner =false);

    }

if (event is CheckUserEvent) {

  final userCheck = await usernameCheck(event.userName);
  if (!userCheck) {
    yield CheckUserState(error: userName = 'This User is Already exists');
  }
}

if (event is SecondCheckUserEvent) {
    yield CheckUserState(error: userName = null);
}

   else if(event is AddUserEvent){

       await registerUser(event.email,event.password,event.userName,event.name);
      yield AddUserState();

    }

   else if (event is ChangeInputEmailEvent){
     yield ChangeInputEmailState(email: email=null);
   }

    else if (event is ChangeInputPasswordEvent){
      yield ChangeInputPasswordState(password: password = null);
    }

    else if (event is RegisteredEvent && userName == null && email == null && password ==null && somethingWrong == false){
      yield RegisteredState();
    }






  }

  Future <bool> usernameCheck(String username) async {
    final _fireStore = FirebaseFirestore.instance;

    final result = await _fireStore
        .collection('users')
        .where('User', isEqualTo: username)
        .get();

    return result.docs.isEmpty;

  }
  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
  Future<void>registerUser(_email,_password,_userName,_name) async {

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();






    try {


      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email.trim(), password: _password.trim());

      _fireStore
          .collection('users').doc(_email.trim())
          .set({
        'Name': _name.trim(),
        'User': _userName.trim(),
        'Uid': newUser.user.uid,
        'Email' : _email.trim(),
        'userImage' : '',
        'mobileToken': await _firebaseMessaging.getToken(),
        'bio':'',
        'caseSearch':setSearchParam(_userName.trim()),
      })
          .catchError((error) {

            print("Failed to add user: $error");
            somethingWrong=true;

          });


    } catch (e) {
      print(e.toString());
      if (e.toString().contains('email-already-in-use')) {
        email = 'Email Aleady In use';
      } else if (e.toString().contains('invalid-email')) {
        email = 'Please Use Correct Email';
      } else if (e.toString().contains('Given String is empty')) {
        email = 'can\'t leave this field empty';
      } else if (e.toString().contains('weak-password')) {
        password = 'Please Write at Least 6 characters';
      } else
        print(e.toString());
    }



}



}

