import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitialState());

  bool block=false;
  int numberOFMessagesAreNotSeen;

  Map<String, String> messages = {};
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _fireStore = FirebaseFirestore.instance;




  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatWithEvent){
      chatWith(token:event.token);
      yield ChatWithState();
    }
    else if (event is ChatInitialEvent){
      getBlockValue(email:event.email ,roomId:event.roomId );
      yield ChatInitialState();
    }

    else if (event is CloseScreenEvent){
      closeScreen();
      yield CloseScreenState();
    }
    else if (event is MessagePlayLoadEvent){
      messagePlayLoad(text: event.message,token: event.token);
      yield MessagePlayLoadState();
    }
    else if (event is AddConversationMessageEvent){
      addConversationMessages(email: event.email,message: event.message,roomId: event.roomId,messageMap: messages);
      yield AddConversationMessageState();
    }
  }


  Future<void> chatWith({String token})async{
    await _fireStore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email).update({
      'chattingWith':token,

    });

  }

  Future<void> getBlockValue({String roomId,email})async{
    await _fireStore.collection('ChatRoom').doc(roomId).get()
        .then((value)  {

      numberOFMessagesAreNotSeen= value.data()['messagesArenotSeen'];
      block = value.data()[email.replaceAll('.', '_')];


    });
  }

  Future<void> closeScreen()async{
    await _fireStore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email).update({
      'chattingWith':null,

    });

  }

  Future<void>messagePlayLoad({String text,token})async  {
    messages = {
      "message": text,
      "sentBy": FirebaseAuth.instance.currentUser.email,
      "timestamp": DateTime.now().toString(),
      'chattingWith':token,
      'messageFromToken':await _firebaseMessaging.getToken(),
    };

  }


  Future<void> addConversationMessages(
  {String roomId,message,email, Map<String, String> messageMap}) async {

    List<String> users = [email,  FirebaseAuth.instance.currentUser.email];

    await _fireStore
        .collection("ChatRoom")
        .doc(roomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    }
    );

    await _fireStore
        .collection('ChatRoom')
        .doc(roomId)
        .update({
      'lastMessage': message,
      'users':users


    });

    String receivingMessagesEmail,chattingWithToken;

    await _fireStore.collection('ChatRoom').doc(roomId).get()
        .then((value)  {
      receivingMessagesEmail = value.data()['users'][0];
    });

    await _fireStore.collection('users').doc(receivingMessagesEmail).get()
        .then((value)  {
      chattingWithToken = value.data()['chattingWith'];
    });

    print(receivingMessagesEmail);
    print(chattingWithToken);
    print(await _firebaseMessaging.getToken());


    if (chattingWithToken != await _firebaseMessaging.getToken()){
      print('working : $numberOFMessagesAreNotSeen');
      await _fireStore
          .collection('ChatRoom')
          .doc(roomId)
          .update({'messagesArenotSeen': numberOFMessagesAreNotSeen++});


    }







  }





}
