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
  final String userName;

  CheckUserEvent({this.userName});

  @override
  List<Object> get props => [this.userName];
}

class SecondCheckUserEvent extends RegisterEvent {
  SecondCheckUserEvent();

  @override
  List<Object> get props => [];
}



class ChangeInputEmailEvent extends RegisterEvent {
  @override
  List<Object> get props => [];
}

class ChangeInputPasswordEvent extends RegisterEvent {
  @override
  List<Object> get props => [];
}

