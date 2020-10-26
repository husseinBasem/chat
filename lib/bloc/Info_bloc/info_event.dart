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

class StartConversationEvent extends InfoEvent {
  final String email, roomId, mobileToken;
  StartConversationEvent({this.email, this.roomId, this.mobileToken});
  @override
  List<Object> get props => [this.email, this.roomId, this.mobileToken];
}

class SwitchToChatScreenEvent extends InfoEvent {
  @override
  List<Object> get props => [];
}

class UserBlocEvent extends InfoEvent {
  final String email, roomId;
  UserBlocEvent({this.roomId, this.email});
  @override
  List<Object> get props => [this.roomId, this.email];
}
