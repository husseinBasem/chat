import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,

     

      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
            child: Column(
              children: <Widget>[
                
                Container(
                  height: 25.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Chats',style: TextStyle(color: Colors.white,fontSize: 20.0),)
                    ],
                  ),
                ),
                SizedBox(height: 10.0,),

                Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.search),
                      Text('Search for users'),
                    ],
                  ),

                  height: 25.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  color: Colors.black45,
                  child: ListTile(

                    title: Text('hussein basem',style: TextStyle(color: Colors.white),),
                    subtitle: Text('hello how are you',style: TextStyle(color: Colors.white70),),
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.lightBlueAccent,
                      child: Text('H',style: TextStyle(color: Colors.white,fontSize: 35.0),),

                    ),
                    trailing:  CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.redAccent,
                      child: Text('1',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                    ),


                  ),
                ),
                Divider(height: 0.0,color: Colors.white10,thickness: 1.0,indent: 75.0,endIndent: 10.0,),
                Container(
                  color: Colors.black45,


                  child: ListTile(
                    title: Text('hussein basem',style: TextStyle(color: Colors.white),),
                    subtitle: Text('hello how are you',style: TextStyle(color: Colors.white70),),
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.lightBlueAccent,
                      child: Text('H',style: TextStyle(color: Colors.white,fontSize: 35.0),),

                    ),
                    trailing:  CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.redAccent,
                      child: Text('1',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                    ),


                  ),
                ),
                Divider(height: 0.0,color: Colors.white10,thickness: 1.0,indent: 75.0,endIndent: 10.0,),
                Container(
                  color: Colors.black45,


                  child: ListTile(
                    title: Text('hussein basem',style: TextStyle(color: Colors.white),),
                    subtitle: Text('hello how are you',style: TextStyle(color: Colors.white70),),
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.lightBlueAccent,
                      child: Text('H',style: TextStyle(color: Colors.white,fontSize: 35.0),),

                    ),
                    trailing:  CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.redAccent,
                      child: Text('1',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                    ),


                  ),
                ),
                Divider(height: 0.0,color: Colors.white10,thickness: 1.0,indent: 75.0,endIndent: 10.0,),
                Container(
                  color: Colors.black45,


                  child: ListTile(
                    title: Text('hussein basem',style: TextStyle(color: Colors.white),),
                    subtitle: Text('hello how are you',style: TextStyle(color: Colors.white70),),
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.lightBlueAccent,
                      child: Text('H',style: TextStyle(color: Colors.white,fontSize: 35.0),),

                    ),
                    trailing:  CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.redAccent,
                      child: Text('1',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                    ),


                  ),
                ),
                Divider(height: 0.0,color: Colors.white10,thickness: 1.0,indent: 75.0,endIndent: 10.0,),
                Container(
                  color: Colors.black45,


                  child: ListTile(
                    title: Text('hussein basem',style: TextStyle(color: Colors.white),),
                    subtitle: Text('hello how are you',style: TextStyle(color: Colors.white70),),
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.lightBlueAccent,
                      child: Text('H',style: TextStyle(color: Colors.white,fontSize: 35.0),),
                    ),
                    trailing:  CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.redAccent,
                      child: Text('1',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                    ),


                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
