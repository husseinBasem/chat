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
  List<Object> get props => [this.error];
}

class SpinnerState extends RegisterState {
  final bool spinner;

  SpinnerState({this.spinner});

  @override
  List<Object> get props => [this.spinner];
}



class ChangeInputEmailState extends RegisterState {
  final String email;

  ChangeInputEmailState({this.email});

  @override
  List<Object> get props => [this.email];
}

class ChangeInputPasswordState extends RegisterState {
  final String password;

  ChangeInputPasswordState({this.password});

  @override
  List<Object> get props => [this.password];
}

class RegisteredState extends RegisterState {
  @override
  List<Object> get props => [];
}

