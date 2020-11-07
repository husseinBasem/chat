part of 'login_bloc.dart';

abstract class LoginEvents extends Equatable {
  const LoginEvents();
}



class SpinnerOnEvent extends LoginEvents {
  @override
  List<Object> get props => [];
}

class SpinnerOffEvent extends LoginEvents {
  @override
  List<Object> get props => [];
}

class InitialEvent extends LoginEvents {
  @override
  List<Object> get props => [];
}

class ChangeInputEmailEvent extends LoginEvents {
  @override
  List<Object> get props => [];
}

class ChangeInputPasswordEvent extends LoginEvents {
  @override
  List<Object> get props => [];
}

class LoggedInEvent extends LoginEvents {
  @override
  List<Object> get props => [];
}

class LoginEvent extends LoginEvents {
  final String email,password;
  LoginEvent({this.email,this.password});
  @override
  List<Object> get props => [email,password];
}


