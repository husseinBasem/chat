import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key key,
    this.onPressed,
    this.networkImage,
    this.changePhoto = true,
    this.height,
    this.width,

  }) : super(key: key);

  final Function onPressed;
  final String networkImage;
  final bool changePhoto;
  final double height,width;


  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          height: height,  //110.0
          width: width,    //100
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
                    image: NetworkImage(networkImage),
                    fit: BoxFit.cover)),
          ),
        ),

        Container(
          child:changePhoto == true? MaterialButton(
            onPressed: onPressed,
            color: Colors.blueAccent,
            height: 25.0,
            child: Icon(
              Icons.add,
              size: 25.0,
              color: Colors.white,
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.white)),
          ):null
        ),
      ],
    );
  }
}