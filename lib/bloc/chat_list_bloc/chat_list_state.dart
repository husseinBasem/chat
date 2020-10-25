part of 'chat_list_bloc.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();
}

class ChatListInitial extends ChatListState {
  @override
  List<Object> get props => [];
}

class SwitchToEditState extends ChatListState {
  @override
  List<Object> get props => [];
}

class SwitchToSearchState extends ChatListState {
  @override
  List<Object> get props => [];
}
