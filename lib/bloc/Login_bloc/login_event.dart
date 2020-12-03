part of 'login_bloc.dart';

abstract class LoginEvents extends Equatable {
  const LoginEvents();
}



class ChangeInputEmailEvent extends LoginEvents {
  @override
  List<Object> get props => [];
}

class ChangeInputPasswordEvent extends LoginEvents {
  @override
  List<Object> get props => [];
}



class LoginEvent extends LoginEvents {
  final String email,password;
  LoginEvent({this.email,this.password});
  @override
  List<Object> get props => [this.email,this.password];
}


