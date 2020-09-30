import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info > {
  File _image;
  final picker = ImagePicker();

  Future getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null){
        _image =File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: <Widget>[

              SizedBox(height: 60.0,),

              Stack(

                overflow: Overflow.visible,

                alignment: AlignmentDirectional.bottomCenter,

                children: <Widget>[



                  Container(
                    height: 110,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blueAccent,
                     // image: DecorationImage(image: AssetImage('images/profile1.jpg'),fit: BoxFit.cover),
                    ),
                    child:_image==null?null: Image.file(_image,fit: BoxFit.cover,),

                  ),





                  MaterialButton(

                    onPressed: () {getImage();},
                    color: Colors.blueAccent,
                    height: 25.0,
                    child: Icon(


                      Icons.add,
                      size: 25.0,
                      color: Colors.white,

                    ),
                    shape: CircleBorder(side:BorderSide(color: Colors.white) ),
                  ),












              ],

              ),

              SizedBox(height: 20.0,),

              Container(
                  alignment: Alignment.center,
                  child: Text( 'Hussein Basem',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),


                  )
              ),

              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Text( 'UI/UX Designer at GTBank & Creative Director at PxDsgn Co. Creating simple digital products over. Let’s talk designs via\n email: sgnco@gmail.com',
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 20),
              FlatButton(
                  onPressed: ()=>print('chating'),
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Icon(Icons.chat_bubble,size: 20.0,color: Colors.white,),
                      SizedBox(width: 10.0,),

                      Text(
                        'Chat',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0)
                        ,)
                    ],
                  )
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.blueGrey,
                onPressed: () {  },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Icon(Icons.chat_bubble,size: 20.0,color: Colors.redAccent,),
                    SizedBox(width: 10.0,),

                    Text(
                      'Block',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16.0)
                      ,)
                  ],
                )
              ),






            ],


          ),
        ),
      ),
    );
  }
}
