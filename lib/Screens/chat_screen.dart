import 'package:chat/Transition/slide_right_route.dart';
import 'package:flutter/material.dart';
import 'package:chat/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/bloc/Chat_bloc/chat_bloc.dart';
import '../Component/image.dart';
import 'chat_list.dart';


class ChatScreen extends StatefulWidget {
  ChatScreen({this.name, this.roomId, this.image, this.token, this.email});

  final String name;
  final String roomId;
  final String image;
  final String token;
  final String email;

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  String _message;
  ChatBloc chatBloc;
  ScrollController _scrollController = ScrollController();
  var cache,cache1;

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc();
    chatBloc.add(ChatWithEvent(token: widget.token));



  }

  @override
  void dispose() {
    super.dispose();
    chatBloc.close();
  }



  @override
  Widget build(BuildContext context,) {

    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(),
      child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
        chatBloc = BlocProvider.of<ChatBloc>(context);
        if(chatBloc.isChatExists==null)
        chatBloc.add(CheckChatEvent(roomId: widget.roomId));

        return Scaffold(
          backgroundColor:Colors.white10 ,


          bottomNavigationBar: chatBloc.isChatExists==true?Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: kMessageContainerDecoration,
            child: chatBloc.heBlocked == false
                ? Row(
              children: chatBloc.youBlocked==false? <Widget>[

                Expanded(
                  child: TextField(
                    maxLines: 50,
                    minLines: 1,
                    controller: messageTextController,
                    onChanged: (value) {
                      _message = value;
                      chatBloc.add(MessagePlayLoadEvent(
                          token: widget.token,
                          message: _message));
                    },
                    decoration: kMessageTextFileDecoration,
                    style: TextStyle(color: Colors.white,),

                  ),
                ),
                ButtonTheme(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minWidth: 0.0,

                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      chatBloc.add(StartConversationEvent(roomId: widget.roomId,email: widget.email,mobileToken: widget.token));

                      messageTextController.clear();
                      chatBloc.add(AddConversationMessageEvent(
                          roomId: widget.roomId,
                          message: _message,
                          email: widget.email));
                      _scrollController.animateTo(
                          _scrollController.position.minScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);


                    },

                    child: Text('Send',
                      style: kSendButtonTextStyle,
                    ),

                  ),
                ),
              ]:<Widget>[

                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      FlatButton(
                          onPressed: (){
                            chatBloc.add(UnBlockEvent(roomId: widget.roomId, email: widget.email));

                          },
                          child: Text('UnBlock',
                            style: TextStyle(color: Colors.white,fontSize: 18.0),),

                      ),

                    ],
                  ),
                )

              ],
            )
                : Container(
              padding: EdgeInsets.only(bottom: 5.0),
              color: Colors.red,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You Got Blocked From ${widget.name}',
                    style: TextStyle(height: 2.0, fontSize: 17.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ) :null,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white10,
            elevation: 0.0,
            actions: <Widget>[
           Expanded(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[

                Row(
                  children: <Widget>[
                    Container(
                      width: 30.0,
                      padding: EdgeInsets.all(0.0),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,size: 25.0,color: Colors.white,),
                        onPressed: ()=>Navigator.pushAndRemoveUntil(context, SlideRightRoute(page: ChatList(),dx: -1.0,dy: 0.0),(Route<dynamic> route) => false),
                        alignment: Alignment.centerRight,
                      ),
                    ),


                  ],
                ),



                Text(widget.name,style: TextStyle(fontSize: 14.0,color: Colors.white,letterSpacing: 2),),

                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: ImageWidget(changePhoto: false,networkImage: widget.image,height: 40.0,width: 40.0,firstLetter: widget.name[0],),
                ),

              ],
            ),
          ),
          ]
        ),





          body: SafeArea(
              child: Stack(
                children: <Widget>[
                 LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SingleChildScrollView(
                        controller: _scrollController,
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),

                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[



                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: chatBloc.heBlocked == true ? null : Container(
                                    child: StreamBuilder(
                                      initialData: cache,
                                        stream: FirebaseFirestore.instance.collection("ChatRoom").doc(widget.roomId).collection("chats")
                                            .orderBy("timestamp", descending: true).snapshots(),

                                        builder: (context, snapshot) {
                                          Future.delayed(Duration(milliseconds: 2500), () {
                                            chatBloc.add(BlockEvent(roomId: widget.roomId, email: widget.email));
                                          });
                                          cache = snapshot.data;
                                          if (chatBloc.numberOFMessagesAreNotSeen == null) {
                                            chatBloc.add(GetValueEvent(email: widget.email, roomId: widget.roomId));
                                            return Container();

                                          } else
                                            if (snapshot.hasData && chatBloc.numberOFMessagesAreNotSeen != null) {

                                            return ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                reverse: true,
                                                itemCount: snapshot.data.docs.length,
                                                itemBuilder: (context, index) {

                                                  final messages = snapshot.data.docs[index];
                                                  final isMe = FirebaseAuth.instance.currentUser.email == messages.data()['sentBy'];
                                                  return Padding(
                                                    padding: EdgeInsets.only(bottom: 5.0,),
                                                    child: Column(
                                                      crossAxisAlignment: isMe ? CrossAxisAlignment.end
                                                          : CrossAxisAlignment.start,
                                                      children: <Widget>[

                                                        Material(
                                                          borderRadius: isMe ? BorderRadius.only(
                                                            topLeft: Radius.circular(30.0),
                                                            bottomLeft: Radius.circular(30.0),
                                                            topRight: Radius.circular(20.0),)
                                                            : BorderRadius.only(
                                                            bottomRight: Radius.circular(30.0),
                                                            topRight: Radius.circular(30.0),
                                                            topLeft: Radius.circular(20.0),),

                                                        color: isMe ? Colors.lightBlueAccent.withOpacity(0.5) : Colors.white10,
                                                          child: Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                                            child: Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context).size.width *0.75),
                                                                child: Row(
                                                                  textDirection: TextDirection.ltr,
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  mainAxisSize: MainAxisSize.min,


                                                                  children: <Widget>[
                                                                    Flexible(
                                                                      child: Text(messages.data()['message'],

                                                                        textAlign: TextAlign.right,
                                                                        style: TextStyle(color: Colors.white, fontSize: 15.0,letterSpacing: 1,fontFamily: 'Markazi'),
                                                                      ),
                                                                    ),

                                                                    SizedBox(width: 5.0,),

                                                                    Text('${messages.data()['timestamp'].substring(10, 16)}',
                                                                      textAlign: TextAlign.left,
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 8.0,
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 5.0,),

                                                                    Container(
                                                                        child: isMe ?
                                                                        StreamBuilder(
                                                                          initialData: cache1,
                                                                          stream: FirebaseFirestore.instance.collection("ChatRoom").doc(widget.roomId).snapshots(),
                                                                          builder: (context, snapshot) {

                                                                            if (snapshot.hasData) {
                                                                              chatBloc.numberOFMessagesAreNotSeen= snapshot.data.data()['messagesArenotSeen'];
                                                                              cache1= snapshot.data;

                                                                              return Container(
                                                                                child: index >= snapshot.data.data()['messagesArenotSeen']
                                                                                    ? Icon(Icons.done_all, color: Colors.white, size: 15.0,)
                                                                                    : Icon(Icons.done, color: Colors.white, size: 15.0,),);
                                                                            } else
                                                                              return Container();
                                                                            },
                                                                        )
                                                                            : null),
                                                                  ],
                                                                ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });

                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ),
                                ),

                              ],
                          ),
                        ),
                      );
                    }),
                Center(
                  child:chatBloc.isChatExists==false? Container(
                    child: RawMaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                        onPressed: (){
                          chatBloc.add(StartConversationEvent(roomId: widget.roomId,mobileToken: widget.token,email: widget.email));
                        },
                      fillColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0,),side: BorderSide(color: Colors.blue,width: 0.5)),
                      child: Text('Start Chat?',style: TextStyle(color: Colors.white,fontSize: 12.0,),),
                    )
                    ,):null,
                )
                ],
              ),
          ),
        );
      }),
    );
  }

}


