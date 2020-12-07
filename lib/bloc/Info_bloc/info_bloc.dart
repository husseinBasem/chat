import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc() : super(InfoInitialState());

  bool userBloc=false;

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {
      if (event is UserBlocEvent) {
      await block(roomId: event.roomId, email: event.email);
      yield UserBlocState(userBloc: userBloc);
    }
    else if (event is InfoInitialEvent) {
      await getBlockValue(email: event.email, roomId: event.roomId);
      yield InfoInitialState();
    }

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
