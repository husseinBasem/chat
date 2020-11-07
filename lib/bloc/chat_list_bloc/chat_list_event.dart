part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
}




class SwitchToChatScreenEvent extends ChatListEvent {
  final String email,mobileToken,roomId;
  SwitchToChatScreenEvent({this.email,this.roomId,this.mobileToken});
  @override
  List<Object> get props => [this.roomId,this.mobileToken,this.email];
}
