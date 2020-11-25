import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NameWidget extends StatelessWidget {
  const NameWidget({
    Key key,
    @required this.editBloc,
    this.color=Colors.black,
    this.suffixColor,
  }) : super(key: key);

  final EditBloc editBloc;
  final Color color,suffixColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.white10,
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
        onChanged: (value) {
          editBloc.add(ChangeNameEvent(value));
        },
        autocorrect: false,
        maxLines: 1,
        initialValue: editBloc.fullName,
        textAlign: TextAlign.left,
        style: GoogleFonts.lora(
          fontSize: 16,
          color: color,
        ),
        decoration: InputDecoration(
          suffixStyle: TextStyle(color:suffixColor ),
            contentPadding: EdgeInsets.only(left: 10.0,right: 5.0),
            suffixText: '${editBloc.fullName.length}/20',
            hintText: 'Name',
            hintStyle:TextStyle(color: Colors.grey) ,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none),
      ),
    );
  }
}