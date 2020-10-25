part of 'edit_bloc.dart';

abstract class EditEvent extends Equatable {
  const EditEvent();
}

class SwitchToChatListEvent extends EditEvent {
  @override
  List<Object> get props => [];
}

class UpdateUserImageEvent extends EditEvent {
  @override
  List<Object> get props => [];
}

class UpdateUserDetailEvent extends EditEvent {
  @override
  List<Object> get props => [];
}

class SignOutEvent extends EditEvent {
  @override
  List<Object> get props => [];
}

class DownloadImageEvent extends EditEvent {
  @override
  List<Object> get props => [];
}

class GetNameEvent extends EditEvent {
  @override
  List<Object> get props => [];
}

class GetImageEvent extends EditEvent {
  @override
  List<Object> get props => [];
}

class ChangeNameEvent extends EditEvent {
  final String name;
  ChangeNameEvent(this.name);
  @override
  List<Object> get props => [this.name];
}

class ChangeBioEvent extends EditEvent {
  final String bio;
  ChangeBioEvent(this.bio);
  @override
  List<Object> get props => [this.bio];
}

class ChangeUserNameEvent extends EditEvent {
  final String userName;
  ChangeUserNameEvent(this.userName);
  @override
  List<Object> get props => [this.userName];
}

class CheckUserEvent extends EditEvent {
  final String userName;

  CheckUserEvent({this.userName});

  @override
  List<Object> get props => [userName];
}

class SecondCheckUserEvent extends EditEvent {
  SecondCheckUserEvent();

  @override
  List<Object> get props => [];
}

class SwitchToLoginEvent extends EditEvent {
  @override
  List<Object> get props => [];
}
