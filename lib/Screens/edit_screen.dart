import 'package:chat/Transition/slide_right_route.dart';
import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Component/bio.dart';
import '../Component/image.dart';
import '../Component/name.dart';
import '../Component/user_name.dart';
import 'login_screen.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  EditBloc editBloc;
  String _firstLetter,_user;
  var cache;



  @override
  void initState() {
    editBloc = EditBloc();
    super.initState();
    editBloc.add(DownloadImageEvent());
    editBloc.add(GetNameEvent());

  }

  @override
  void dispose() {
    super.dispose();
    editBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: BlocProvider<EditBloc>(
        create: (context) => EditBloc(),
        child: SafeArea(
          child: BlocBuilder<EditBloc, EditState>(builder: (context, state) {


            editBloc = BlocProvider.of<EditBloc>(context);
            return ModalProgressHUD(
              inAsyncCall: editBloc.spinner,
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: Colors.white10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ButtonTheme(
                              padding: EdgeInsets.only(right: 30.0,left: 10.0),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 17,color: Colors.white),
                                ),
                              ),
                            ),
                            ButtonTheme(
                              padding: EdgeInsets.only(left: 50.0,right: 5.0),
                              child: FlatButton(
                                onPressed: () {
                                  print(editBloc.userNameError);
                                  if (editBloc.userName != null && editBloc.userName.length>2) {
                                    if(editBloc.fullName.isEmpty ==false&& editBloc.userName.isEmpty ==false){
                                    if (editBloc.userNameError == null) {
                                      editBloc.add(UpdateUserDetailEvent());
                                      Navigator.of(context).pop();
                                    }
                                    else {
                                      flutterToast('This User is Already exists');

                                    }
                                    }else{
;


                                      flutterToast('Your Name or Username is Empty');
                                    }
                                  }else if(editBloc.userName.length<=2) {

                                    flutterToast('Username Must be Atleast 3 characters');

                                  }

                                },
                                child: Text(
                                  'Done',
                                  style: TextStyle(fontSize: 17,color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      FutureBuilder(
                        initialData: cache,
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser.email)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              cache = snapshot.data;
                              if (editBloc.fullName == null) {
                                editBloc.fullName = snapshot.data.data()['Name'];
                                _firstLetter = editBloc.fullName[0];
                              }
                              if (editBloc.bio == null)
                                editBloc.bio = snapshot.data.data()['bio'];
                              _user = snapshot.data.data()['User'];
                              editBloc.imageLink = snapshot.data.data()['userImage'];

                              return Column(
                                  children: <Widget>[
                                Container(
                                  height:200.0,
                                  color: Colors.white10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ImageWidget(
                                        networkImage: editBloc.imageLink,
                                        onPressed:() {editBloc.add(GetImageEvent());},
                                        height: 130.0,
                                        width: 130.0,
                                          firstLetter: _firstLetter,
                                        ),
                                    ],
                                  ),
                                ),
//
                                Divider(
                                  color: Colors.grey,
                                  thickness: 0.6,
                                  height: 0.0,
                                ),
                                NameWidget(editBloc: editBloc,color: Colors.white,suffixColor: Colors.grey,

                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 0.7,
                                  height: 0.0,
//                                indent: 10.0,
                                ),
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Enter your name and add an optional profile photo.',style: TextStyle(color: Colors.white,fontFamily: 'Lora',fontSize: 12.0),)),
                                ),
                                SizedBox(height: 25.0,),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 0.6,
                                  height: 0.0,
                                ),

                                BioWidget(editBloc: editBloc,color: Colors.white,suffixColor: Colors.grey,
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 0.7,
                                  height: 0.0,
                                ),
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Any details such as age, occupation or city. Example: 23 y.o. designer from San Francisco.',style: TextStyle(color: Colors.white,fontFamily: 'Lora',fontSize: 12.0),

                                    ),
                                  ),
                                ),



                                SizedBox(
                                  height: 20.0,
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 0.6,
                                  height: 0.0,
                                ),
                                 UserNameWidget(
                                 editBloc: editBloc, userName: _user,color: Colors.grey,
                                 ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 0.6,
                                  height: 0.0,
                                ),


                                 ]);
                                } else {
                              return Container();
                            }
                          }),

                      SizedBox(
                        height: 50.0,
                      ),
                      FlatButton(
                          onPressed: () {
                            editBloc.add(SignOutEvent());
                            Navigator.pushAndRemoveUntil(context, SlideRightRoute(page: LoginScreen(),dx: -1.0,dy: 0.0),(Route<dynamic> route) => false);

                          },
                          child: Container(
//                          color: Colors.white10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RotationTransition(

                                  turns: AlwaysStoppedAnimation(180/360),
                                  child: Icon(
                                    Icons.exit_to_app,
                                    size: 22.0,
                                    color: Colors.redAccent,
                                    textDirection: TextDirection.ltr,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Sign Out',
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 18.0),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
  void flutterToast(String text){

    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,

    );

  }
}








