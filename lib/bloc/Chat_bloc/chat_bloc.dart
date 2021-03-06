import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(InitialState());

  bool heBlocked=false,youBlocked = false,isChatExists;
  int numberOFMessagesAreNotSeen;


  Map<String, String> messages = {};
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _fireStore = FirebaseFirestore.instance;

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatWithEvent) {
      await chatWith(token: event.token);
      yield ChatWithState();

    } else if (event is GetValueEvent) {
      await getNumberUnSeenMessageValue(
          email: event.email, roomId: event.roomId);

      yield GetValueState();

    } else if (event is MessagePlayLoadEvent) {
      messagePlayLoad(text: event.message, token: event.token);
      yield MessagePlayLoadState();

    } else if (event is AddConversationMessageEvent) {
      await addConversationMessages(
          email: event.email,
          message: event.message,
          roomId: event.roomId,
          messageMap: messages);
      yield AddConversationMessageState();

    } else if (event is BlockEvent) {
      await getBlockValue(email: event.email, roomId: event.roomId);
      yield BlockState();
    } else if (event is UnBlockEvent){
      await bloc(roomId: event.roomId,email: event.email);
      yield UnBlockState();
    } else if (event is StartConversationEvent){
      await startConversion(email: event.email,roomId: event.roomId,mobileToken: event.mobileToken);
      isChatExists = true;

      yield StartConversationState();

    }
    else if (event is CheckChatEvent){
      await checkChat(roomId: event.roomId);
      yield CheckChatState();
    }

  }

  Future<void> chatWith({String token}) async {
    await _fireStore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({
      'chattingWith': token,
    });
  }

  Future<void> getBlockValue({String roomId, email}) async {
    await _fireStore.collection('ChatRoom').doc(roomId).get().then((value)async  {

      if (value.data() != null) {
        youBlocked = value.data()[email.replaceAll('.', '_')];
        heBlocked =
        value.data()[ FirebaseAuth.instance.currentUser.email.replaceAll(
            '.', '_')];
      }
    });
  }

  Future<void> getNumberUnSeenMessageValue({String roomId, email}) async {
    await _fireStore.collection('ChatRoom').doc(roomId).get().then((value) {
      if (value.data() !=null)
      numberOFMessagesAreNotSeen = value.data()['messagesArenotSeen'];
      else
        numberOFMessagesAreNotSeen =0;

    });
  }



  Future<void> messagePlayLoad({String text, token}) async {
    messages = {
      "message": text,
      "sentBy": FirebaseAuth.instance.currentUser.email,
      "timestamp": DateTime.now().toString(),
      'chattingWith': token,
      'messageFromToken': await _firebaseMessaging.getToken(),
    };
  }

  Future<void> addConversationMessages(
      {String roomId, message, email, Map<String, String> messageMap}) async {

    List<String> users = [email, FirebaseAuth.instance.currentUser.email];

    String receivingMessagesEmail, chattingWithToken;

    await _fireStore.collection('ChatRoom').doc(roomId).get().then((value) {
      receivingMessagesEmail = value.data()['users'][0];
    });

    await _fireStore
        .collection('users')
        .doc(receivingMessagesEmail)
        .get()
        .then((value) {
      chattingWithToken = value.data()['chattingWith'];
    });

    if (chattingWithToken != await _firebaseMessaging.getToken()) {
      await _fireStore
          .collection('ChatRoom')
          .doc(roomId)
          .update({'messagesArenotSeen': ++numberOFMessagesAreNotSeen});
    }else {
      await _fireStore
          .collection('ChatRoom')
          .doc(roomId)
          .update({'messagesArenotSeen': 0});

    }

    await _fireStore
        .collection("ChatRoom")
        .doc(roomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });

    await _fireStore
        .collection('ChatRoom')
        .doc(roomId)
        .update({
      'lastMessage': message,
      'users': users,
      "timeStamp": DateTime.now().toString(),

        });
  }
  Future<void> bloc({String roomId, email}) async {
    await FirebaseFirestore.instance.collection('ChatRoom').doc(roomId).update(
      {email.replaceAll('.', '_'): false},
    );
  }




  Future <void>startConversion({String email, roomId, mobileToken}) async {


    List<String> users = [email, FirebaseAuth.instance.currentUser.email];




        Map<String, dynamic> chatRoomMap =  {
          "users": users,
          "chatRoomId": roomId,
          "timeStamp": DateTime.now().toString().toString(),
          'lastMessage': '',
          'messagesArenotSeen': 0,
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
  Future <void> checkChat({String roomId})async{

    await FirebaseFirestore.instance.collection('ChatRoom').get().then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        if (roomId == doc['chatRoomId']) {
          isChatExists = true;
          break;
        }
        else {
          isChatExists = false;
        }
      }
    });
  }

}
