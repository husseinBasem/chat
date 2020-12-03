part of 'login_bloc.dart';

abstract class LoginStates extends Equatable {
  const LoginStates();
}

class LoginInitial extends LoginStates {
  @override
  List<Object> get props => [];
}



class SpinnerState extends LoginStates {
  final bool spinner;

  SpinnerState({this.spinner});

  @override
  List<Object> get props => [this.spinner];
}


class ChangeInputEmailState extends LoginStates {
  final String email;

  ChangeInputEmailState({this.email});

  @override
  List<Object> get props => [this.email];
}

class ChangeInputPasswordState extends LoginStates {
  final String password;

  ChangeInputPasswordState({this.password});

  @override
  List<Object> get props => [this.password];
}

class LoggedInState extends LoginStates {
  @override
  List<Object> get props => [];
}

class LoginState extends LoginStates {
  @override
  List<Object> get props => [];
}

