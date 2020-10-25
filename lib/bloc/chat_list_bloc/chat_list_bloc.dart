import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(ChatListInitial());

  @override
  Stream<ChatListState> mapEventToState(
    ChatListEvent event,
  ) async* {
    if (event is SwitchToEditEvent) {
      yield SwitchToEditState();
    } else if (event is SwitchToSearchEvent) {
      yield SwitchToSearchState();
    }
  }
}
