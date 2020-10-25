import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameWidget extends StatelessWidget {
  const NameWidget({
    Key key,
    @required this.editBloc,
  }) : super(key: key);

  final EditBloc editBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
        onChanged: (value) {
          editBloc.add(ChangeNameEvent(value));
        },
        autocorrect: false,
        maxLines: 1,
        initialValue: editBloc.fullName,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10.0),
            suffixText: '${editBloc.fullName.length}/20',
            hintText: 'Name',
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none),
      ),
    );
  }
}