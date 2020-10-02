import 'package:chat/info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'info_screen.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {
  String _search  ;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10.0),


            child: ListView(
              shrinkWrap: true,




              children: <Widget>[



                Row(



                  children: <Widget>[








                     Expanded(
                       child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          height: 35.0,
                          child: TextField(

                            autofocus: true,
                            style: TextStyle(color: Colors.white,),
                            cursorColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                _search = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search For Users',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black38,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                            ),
                          ),
                        ),
                     ),


                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'chat_list');
                      },
                      child: Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 15.0),),
                    ),

                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: StreamBuilder(
                    
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('User',
                            isEqualTo: _search)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {

                            return  Column(
                              children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) => Info(
                                      email: snapshot.data.documents[index]
                                            .data()['Email']
                                            .toString(),
                                      roomId: getChatID(FirebaseAuth.instance.currentUser.email.toString(),snapshot.data.documents[index]
                                          .data()['Email'].toString()
                                          .toString() )
                                        ),
                                      ));
                                },
                                title: Text(
                                  snapshot.data.documents[index]
                                      .data()['Name']
                                      .toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                leading: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.lightBlueAccent,
                                  child: Text(
                                    snapshot.data.documents[index]
                                        .data()['Name']
                                        .toString()[0]
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            )
                              ],

                            );
                          },
                          itemCount: snapshot.data.documents.length,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),

          ),
    ),
    );
  }

  getChatID(String firstUser, String secondUser) {
    if (firstUser.substring(0, 1).codeUnitAt(0) >= secondUser.substring(0, 1).codeUnitAt(0)) {
      return '$firstUser\_$secondUser';
    } else{

      return '$secondUser\_$firstUser';
    }
  }


}
