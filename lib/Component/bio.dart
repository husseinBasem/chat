import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BioWidget extends StatelessWidget {
  const BioWidget({
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
      color: Colors.white10,
        child: TextFormField(
          onChanged: (value) {
            editBloc.add(ChangeBioEvent(value));
          },
          inputFormatters: [LengthLimitingTextInputFormatter(140)],
          autocorrect: false,
          maxLines: 5,
          minLines: 1,
          initialValue: editBloc.bio,
          textAlign: TextAlign.left,
          style: GoogleFonts.lora(fontSize: 16, color: color),
          decoration: InputDecoration(
            suffixStyle: TextStyle(color: suffixColor,),
            contentPadding: EdgeInsets.only(left: 10.0,right: 5.0),
            suffixText: ' ${editBloc.bio.length}/140',
            hintText: 'bio',
            hintStyle:TextStyle(color: Colors.grey),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ));
  }
}