part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class ChangeUserState extends SearchState {
  final String search;
  ChangeUserState({this.search});

  @override
  List<Object> get props => [this.search];
}




