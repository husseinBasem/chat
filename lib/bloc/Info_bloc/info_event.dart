part of 'info_bloc.dart';

abstract class InfoEvent extends Equatable {
  const InfoEvent();
}

class InfoInitialEvent extends InfoEvent {
  final String roomId, email;
  InfoInitialEvent({this.roomId, this.email});
  @override
  List<Object> get props => [this.roomId, this.email];
}




class UserBlocEvent extends InfoEvent {
  final String email, roomId;
  UserBlocEvent({this.roomId, this.email});
  @override
  List<Object> get props => [this.roomId, this.email];
}

