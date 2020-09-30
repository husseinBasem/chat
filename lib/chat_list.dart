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
            padding: EdgeInsets.all(10.0),
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
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  height: 35.0,
                  child: TextField(
                    autofocus: false,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search For Users',
                      prefixIcon: Icon(Icons.search,color: Colors.black38,),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                      




                    ),

                    onTap: (){
                      Navigator.pushNamed(context, 'search_screen');
                    },


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
