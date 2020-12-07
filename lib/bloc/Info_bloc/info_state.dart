part of 'info_bloc.dart';

abstract class InfoState extends Equatable {
  const InfoState();
}

class InfoInitialState extends InfoState {
  @override
  List<Object> get props => [];
}




class UserBlocState extends InfoState {
  final bool userBloc;
  UserBlocState({this.userBloc});
  @override
  List<Object> get props => [this.userBloc];
}

