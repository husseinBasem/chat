part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatWithState extends ChatState{
  @override
  List<Object> get props => [];
}

class ChatInitialState extends ChatState{
  @override
  List<Object> get props => [];
}

class CloseScreenState extends ChatState{
  @override
  List<Object> get props => [];
}

class MessagePlayLoadState extends ChatState{

  @override
  List<Object> get props => [];
}

class AddConversationMessageState extends ChatState{

  @override
  List<Object> get props => [];
}
