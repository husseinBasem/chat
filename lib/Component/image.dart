import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key key,
    @required this.networkImage,
    @required this.firstLetter,
    this.height,
     this.width,
    this.changePhoto = true,
    this.onPressed,



  }) : super(key: key);

  final Function onPressed;
  final String networkImage,firstLetter;
  final bool changePhoto;
  final double height,width;


  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: networkImage,
          imageBuilder: (context,imageProvider)=>
            Container(
              height: height,  //110.0
              width: width,    //100
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: imageProvider,
                  fit: BoxFit.cover,
                ),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blueAccent,
                  ),
            ),
          errorWidget:(context,url,error)=>
              Container(
                height: height,  //110.0
                width: width,    //100
                decoration: BoxDecoration(
//                    image: DecorationImage(
//                      fit: BoxFit.cover, image: null,
//                    ),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blueAccent,
                ),
              
              child: Center(child: Text(firstLetter.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: width/2,),)),
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