part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBiometricsEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class ChangeUsernameEvent extends LoginEvent {
  final String value;

  ChangeUsernameEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class ChangePasswordEvent extends LoginEvent {
  final String value;

  ChangePasswordEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class SubmitEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginWithBiometricsEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}
