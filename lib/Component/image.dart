import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key key,
    @required this.editBloc,
  }) : super(key: key);

  final EditBloc editBloc;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          height: 110.0,
          width: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blueAccent,
          ),
          child: Container(
            height: 110.0,
            width: 100.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blueAccent,
                image: DecorationImage(
                    image: NetworkImage(editBloc.imageLink),
                    fit: BoxFit.cover)),
          ),
        ),
        MaterialButton(
          onPressed: () {
            editBloc.add(GetImageEvent());
          },
          color: Colors.blueAccent,
          height: 25.0,
          child: Icon(
            Icons.add,
            size: 25.0,
            color: Colors.white,
          ),
          shape: CircleBorder(side: BorderSide(color: Colors.white)),
        ),
      ],
    );
  }
}