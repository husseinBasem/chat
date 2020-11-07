part of 'login_bloc.dart';

abstract class LoginStates extends Equatable {
  const LoginStates();
}

class LoginInitial extends LoginStates {
  @override
  List<Object> get props => [];
}



class SpinnerOnState extends LoginStates {
  final bool spinner;

  SpinnerOnState({this.spinner});

  @override
  List<Object> get props => [spinner];
}

class SpinnerOffState extends LoginStates {
  final bool spinner;

  SpinnerOffState({this.spinner});

  @override
  List<Object> get props => [spinner];
}

class ChangeInputEmailState extends LoginStates {
  final String email;

  ChangeInputEmailState({this.email});

  @override
  List<Object> get props => [email];
}

class ChangeInputPasswordState extends LoginStates {
  final String password;

  ChangeInputPasswordState({this.password});

  @override
  List<Object> get props => [password];
}

class LoggedInState extends LoginStates {
  @override
  List<Object> get props => [];
}

class LoginState extends LoginStates {
  @override
  List<Object> get props => [];
}

