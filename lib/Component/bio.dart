import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BioWidget extends StatelessWidget {
  const BioWidget({
    Key key,
    @required this.editBloc,
  }) : super(key: key);

  final EditBloc editBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 17, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10.0),
            suffixText: editBloc.bio.length.toString() + '/140',
            hintText: 'bio',
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ));
  }
}