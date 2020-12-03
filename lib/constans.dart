import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 14.0,

);

const kMessageTextFileDecoration = InputDecoration(
  contentPadding: EdgeInsets.only(left: 7.0,top: 5.0,bottom: 5.0,),
  hintText: 'Type Your Message Here...',
  hintStyle: TextStyle(color: Colors.grey,fontSize: 12.0),
  border: InputBorder.none,

//  hintMaxLines: 75,

);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide( color: Colors.white10, width: 2.0),

  ),

);

const KTextFieldDecoration = InputDecoration(
hintText: '',
contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(32.0)),),
enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent,width: 1.0), borderRadius: BorderRadius.all(Radius.circular(32.0)),),
focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0), borderRadius: BorderRadius.all(Radius.circular(32.0)),),
  hintStyle: TextStyle(color: Colors.white60),



);