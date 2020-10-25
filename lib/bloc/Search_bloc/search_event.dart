part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class ChangeUserEvent extends SearchEvent {
  final String search;
  ChangeUserEvent({this.search});

  @override
  List<Object> get props => [this.search];
}

class SwitchToChatListEvent extends SearchEvent {
  @override
  List<Object> get props => [];
}

class SwitchToInfoEvent extends SearchEvent {
  @override
  List<Object> get props => [];
}
