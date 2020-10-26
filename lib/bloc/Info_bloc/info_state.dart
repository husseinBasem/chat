part of 'info_bloc.dart';

abstract class InfoState extends Equatable {
  const InfoState();
}

class InfoInitialState extends InfoState {
  @override
  List<Object> get props => [];
}

class StartConversationState extends InfoState {
  final String email, roomId, mobileToken;
  StartConversationState({this.email, this.roomId, this.mobileToken});
  @override
  List<Object> get props => [this.email, this.roomId, this.mobileToken];
}

class SwitchToChatScreenState extends InfoState {
  @override
  List<Object> get props => [];
}

class UserBlocState extends InfoState {
  final bool userBloc;
  UserBlocState({this.userBloc});
  @override
  List<Object> get props => [this.userBloc];
}
