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
    this.boxShadow,



  }) : super(key: key);

  final Function onPressed;
  final String networkImage,firstLetter;
  final bool changePhoto;
  final double height,width;
  final BoxShadow boxShadow;


  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: networkImage,
          placeholder: (context, url) => Center(child: SizedBox(width: width/3,height: width/3,child: CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 2.0,))),
          imageBuilder: (context,imageProvider)=>
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                boxShadow:boxShadow==null?null:[boxShadow],
                image: DecorationImage(
                    image: imageProvider,
                  fit: BoxFit.fill
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

                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blueAccent,
                ),

                child: Center(child: Text(firstLetter.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: width/2,),)),
              ),






        ),

        Container(
          child:changePhoto == true? MaterialButton(
            onPressed: onPressed,
            color: Colors.white,
//            height: 30.0,
            child: Icon(
              Icons.add_photo_alternate,
              size: 25.0,
              color: Color(0xff4b4c57),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.white)),
          ):null
        ),
      ],
    );
  }
}