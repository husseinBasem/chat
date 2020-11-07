import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {}

class AddUserState extends RegisterState {
  AddUserState();

  @override
  List<Object> get props => [];
}

class InitialState extends RegisterState {
  @override
  List<Object> get props => [];
}



class CheckUserState extends RegisterState {
  final String error;

  CheckUserState({this.error});

  @override
  List<Object> get props => [error];
}

class SpinnerOnState extends RegisterState {
  final bool spinner;

  SpinnerOnState({this.spinner});

  @override
  List<Object> get props => [spinner];
}

class SpinnerOffState extends RegisterState {
  final bool spinner;

  SpinnerOffState({this.spinner});

  @override
  List<Object> get props => [spinner];
}

class ChangeInputEmailState extends RegisterState {
  final String email;

  ChangeInputEmailState({this.email});

  @override
  List<Object> get props => [email];
}

class ChangeInputPasswordState extends RegisterState {
  final String password;

  ChangeInputPasswordState({this.password});

  @override
  List<Object> get props => [password];
}

class RegisteredState extends RegisterState {
  @override
  List<Object> get props => [];
}

