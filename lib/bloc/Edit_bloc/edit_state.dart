part of 'edit_bloc.dart';

abstract class EditState extends Equatable {
  const EditState();
}

class EditInitial extends EditState {
  @override
  List<Object> get props => [];
}

class SwitchToChatListState extends EditState {
  @override
  List<Object> get props => [];
}

class UpdateUserImageState extends EditState {
  @override
  List<Object> get props => [];
}

class UpdateUserDetailState extends EditState {
  @override
  List<Object> get props => [];
}

class SignOutState extends EditState {
  @override
  List<Object> get props => [];
}

class DownloadImageState extends EditState {
  @override
  List<Object> get props => [];
}

class GetNameState extends EditState {
  @override
  List<Object> get props => [];
}

class GetImageState extends EditState {
  @override
  List<Object> get props => [];
}

class ChangeNameState extends EditState {
  final String name;

  ChangeNameState({this.name});
  @override
  List<Object> get props => [this.name];
}

class ChangeBioState extends EditState {
  final String bio;

  ChangeBioState({this.bio});
  @override
  List<Object> get props => [this.bio];
}

class ChangeUserNameState extends EditState {
  final String userName;

  ChangeUserNameState({this.userName});
  @override
  List<Object> get props => [this.userName];
}

class CheckUserState extends EditState {
  final String error;

  CheckUserState({this.error});

  @override
  List<Object> get props => [error];
}

class SwitchToLoginState extends EditState {
  @override
  List<Object> get props => [];
}
