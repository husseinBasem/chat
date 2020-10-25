part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
}

class SwitchToEditEvent extends ChatListEvent {
  @override
  List<Object> get props => [];
}

class SwitchToSearchEvent extends ChatListEvent {
  @override
  List<Object> get props => [];
}
