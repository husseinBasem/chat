import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {}

class AddUserEvent extends RegisterEvent {
  final String userName, email, password, name;

  AddUserEvent(
    this.userName,
    this.email,
    this.password,
    this.name,
  );

  @override
  List<Object> get props => [this.userName, this.email, this.password, this.name];
}

class CheckUserEvent extends RegisterEvent {
  final String userNameError;

  CheckUserEvent({this.userNameError});

  @override
  List<Object> get props => [this.userNameError];
}

class SecondCheckUserEvent extends RegisterEvent {
  final String userNameError;

  SecondCheckUserEvent({this.userNameError,});

  @override
  List<Object> get props => [this.userNameError];
}



class ChangeInputEmailEvent extends RegisterEvent {
  @override
  List<Object> get props => [];
}

class ChangeInputPasswordEvent extends RegisterEvent {
  @override
  List<Object> get props => [];
}

