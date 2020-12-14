import 'package:chat/bloc/register_bloc/events.dart';
import 'package:chat/bloc/register_bloc/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent,RegisterState>{
  RegisterBloc() : super(InitialState());



String email,password,userNameError,userName;
bool showSpinner=false;
bool somethingWrong=false;

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {



if (event is CheckUserEvent) {

  if (event.userNameError.length<3){
    yield CheckUserState(error: userNameError = 'Username Must be Atleast 3 characters');

  }

  else if ( !(await usernameCheck(event.userNameError))) {
    yield CheckUserState(error: userNameError = 'This User is Already exists');
  }

}

   else if (event is SecondCheckUserEvent) {
    yield CheckUserState(error: userNameError = null);

}

   else if(event is AddUserEvent) {


  yield SpinnerState(spinner: showSpinner = true);
  if (userNameError == null && event.userName.length > 2) {


  await registerUser(event.email, event.password, event.userName, event.name);

  if (email == null && password == null && somethingWrong == false) {
    yield SpinnerState(spinner: showSpinner = false);
    yield RegisteredState();
    return;
  }
}



     yield SpinnerState(spinner: showSpinner=false);
     yield AddUserState();



}

   else if (event is ChangeInputEmailEvent){
     yield ChangeInputEmailState(email: email=null);
   }

    else if (event is ChangeInputPasswordEvent){
      yield ChangeInputPasswordState(password: password = null);
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
      if(temp.length>=3)
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
      } 

    }



}



}

