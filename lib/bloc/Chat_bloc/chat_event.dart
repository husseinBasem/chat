part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class ChatWithEvent extends ChatEvent {
  final String token;
  ChatWithEvent({this.token});

  @override
  List<Object> get props => [this.token];
}

class GetValueEvent extends ChatEvent {
  final String email, roomId;
  GetValueEvent({this.roomId, this.email});
  @override
  List<Object> get props => [this.roomId, this.email];
}

class MessagePlayLoadEvent extends ChatEvent {
  final String message, token;
  MessagePlayLoadEvent({this.message, this.token});
  @override
  List<Object> get props => [this.message, this.token];
}

class AddConversationMessageEvent extends ChatEvent {
  final String roomId, message, email;
  AddConversationMessageEvent({this.roomId, this.message, this.email});
  @override
  List<Object> get props => [this.message, this.roomId, this.email];
}

class NumberOfMessagesAreNotSeen extends ChatEvent {
  @override
  List<Object> get props => [];
}

class BlockEvent extends ChatEvent {
  final String email, roomId;
  BlockEvent({this.email, this.roomId});

  @override
  List<Object> get props => [this.email, this.roomId];
}

