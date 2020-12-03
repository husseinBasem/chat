import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserNameWidget extends StatelessWidget {
  const UserNameWidget({
    Key key,
    @required this.editBloc,
    @required this.userName,
    this.color=Colors.black,
  }) : super(key: key);

  final EditBloc editBloc;
  final String userName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      child: TextFormField(
        onChanged: (value) {
          editBloc.add(ChangeUserNameEvent(userName: value));
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
          fontSize: 16,
          color: color,
          fontFamily: 'Lora'
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10.0),

            prefixStyle:TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Lora') ,
            prefixText: 'Username  ',
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