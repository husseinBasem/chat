import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc() : super(InfoInitialState());

  bool userBloc=false;

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {
    if (event is StartConversationEvent) {
     await startConversion(
          email: event.email,
          roomId: event.roomId,
          mobileToken: event.mobileToken);
      yield StartConversationState(email: event.email, roomId: event.roomId);
    } else  if (event is UserBlocEvent) {
      await block(roomId: event.roomId, email: event.email);
      yield UserBlocState(userBloc: userBloc);
    }
    else if (event is InfoInitialEvent) {
      await getBlockValue(email: event.email, roomId: event.roomId);
      yield InfoInitialState();
    }

  }

  startConversion({String email, roomId, mobileToken}) async {
    String lastMessage, sender;
    int unSeenMessages;

    List<String> users = [email, FirebaseAuth.instance.currentUser.email];

    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(roomId)
        .get()
        .then((value) {
          if(value.data() !=null) {
            lastMessage = value.data()['lastMessage'];
            sender = value.data()['users'][1];
            unSeenMessages = value.data()['messagesArenotSeen'];
          }
    });

    Map<String, dynamic> chatRoomMap =  {
      "users": users,
      "chatRoomId": roomId,
      "timeStamp": DateTime.now().toString().toString(),
      'lastMessage': lastMessage,
      'messagesArenotSeen': sender == FirebaseAuth.instance.currentUser.email
          ? unSeenMessages
          : 0,
       FirebaseAuth.instance.currentUser.email.replaceAll('.', '_'): false,
       email.replaceAll('.', '_'): false,
    };

    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(roomId)
        .set(chatRoomMap)
        .catchError((onError) {
      print(onError);
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({'chattingWith': mobileToken});
  }

  Future<void> block({String roomId, email}) async {
    userBloc = !userBloc;
    await FirebaseFirestore.instance.collection('ChatRoom').doc(roomId).update(
      {email.replaceAll('.', '_'): userBloc},
    );
  }

  Future<void> getBlockValue({String roomId, email}) async {
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(roomId)
        .get()
        .then((value) {
          if(value.data() != null)
      userBloc = value.data()[email.replaceAll('.', '_')];
    });
  }
}
