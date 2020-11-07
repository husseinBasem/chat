import 'package:chat/Transition/slide_right_route.dart';
import 'package:chat/bloc/Edit_bloc/edit_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String _userName;


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
      backgroundColor: Colors.white,
      body: BlocProvider<EditBloc>(
        create: (context) => EditBloc(),
        child: SafeArea(
          child: BlocBuilder<EditBloc, EditState>(builder: (context, state) {
            editBloc = BlocProvider.of<EditBloc>(context);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ButtonTheme(
                            padding: EdgeInsets.only(right: 30.0),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'cancel',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          ButtonTheme(
                            padding: EdgeInsets.only(left: 50.0),
                            child: FlatButton(
                              onPressed: () {
                                if (editBloc.userName != null) {
                                  if (editBloc.userNameError == null) {
                                    editBloc.add(UpdateUserDetailEvent());
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                              child: Text(
                                'done',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser.email)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (editBloc.fullName == null)
                                editBloc.fullName =
                                    snapshot.data.data()['Name'];
                              if (editBloc.bio == null)
                                editBloc.bio = snapshot.data.data()['bio'];
                              _userName = snapshot.data.data()['User'];
                              editBloc.imageLink =
                                  snapshot.data.data()['userImage'];

                              return Column(children: <Widget>[
                                ImageWidget(
                                  networkImage: editBloc.imageLink,
                                  onPressed:() {editBloc.add(GetImageEvent());},
                                  height: 110.0,
                                  width: 100.0,
                                    firstLetter: editBloc.fullName[0],
                                  ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 2.0,
                                  height: 1.0,
                                ),
                                NameWidget(editBloc: editBloc),
                                Divider(
                                  color: Colors.black,
                                  thickness: 2.0,
                                  height: 1.0,
                                  indent: 10.0,
                                ),
                                UserNameWidget(
                                    editBloc: editBloc, userName: _userName),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 2.0,
                                  height: 1.0,
                                  indent: 10.0,
                                ),
                                BioWidget(editBloc: editBloc),
                              ]);
                            } else {
                              return Container();
                            }
                          }),
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                        height: 1.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FlatButton(
                          onPressed: () {
                            editBloc.add(SignOutEvent());
                            Navigator.pushAndRemoveUntil(context, SlideRightRoute(page: LoginScreen(),dx: -1.0,dy: 0.0),(Route<dynamic> route) => false);

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.chat_bubble,
                                size: 20.0,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 16.0),
                              )
                            ],
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
}








