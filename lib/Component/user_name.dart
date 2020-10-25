import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:flutter/material.dart';

class UserNameWidget extends StatelessWidget {
  const UserNameWidget({
    Key key,
    @required this.editBloc,
    @required this.userName,
  }) : super(key: key);

  final EditBloc editBloc;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        onChanged: (value) {
          editBloc.add(ChangeUserNameEvent(value));
          if (userName != value) {
            if (editBloc.userNameError == null) {
              editBloc.add(CheckUserEvent(userName: value));
            } else {
              editBloc.add(SecondCheckUserEvent());
            }
          }
        },
        autocorrect: false,
        maxLines: 1,
        initialValue: userName,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10.0),
            hintText: 'User Name',
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorText: editBloc.userNameError,
            focusedErrorBorder: InputBorder.none,
            errorStyle: TextStyle(color: Colors.red, height: 0.1)),
      ),
    );
  }
}