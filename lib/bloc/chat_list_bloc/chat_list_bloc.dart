import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(ChatListInitial());

  @override
  Stream<ChatListState> mapEventToState(
    ChatListEvent event,
  ) async* {
 if (event is SwitchToChatScreenEvent){
      startConversion(email: event.email,roomId:event.roomId ,mobileToken:event.mobileToken );
      yield SwitchToChatScreenState();
    }

  }


  startConversion({String email, roomId, mobileToken}) async {
    String lastMessage, sender;
    int unSeenMessages;
    bool heBlocked,youBlocked;
    String time;

    List<String> users = [email, FirebaseAuth.instance.currentUser.email];

    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(roomId)
        .get()
        .then((value) {
      lastMessage = value.data()['lastMessage'];
      sender = value.data()['users'][1];
      unSeenMessages = value.data()['messagesArenotSeen'];
      youBlocked = value.data()[email.replaceAll('.', '_')];
      heBlocked = value.data()[FirebaseAuth.instance.currentUser.email.replaceAll('.', '_')];
      time = value.data()['timeStamp'];

    });

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": roomId,
      "timeStamp": time,
      'lastMessage': lastMessage,
      'messagesArenotSeen': sender == FirebaseAuth.instance.currentUser.email
          ? unSeenMessages
          : 0,
      FirebaseAuth.instance.currentUser.email.replaceAll('.', '_'): heBlocked,
      email.replaceAll('.', '_'): youBlocked,
    };

    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(roomId)
        .update(chatRoomMap)
        .catchError((onError) {
      print(onError);
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({'chattingWith': mobileToken});
  }

}
