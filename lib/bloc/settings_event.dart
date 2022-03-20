part of 'settings_bloc.dart';

class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckBiometricsEvent extends SettingsEvent {
  @override
  List<Object?> get props => [];
}

class ApplyBiometricsEvent extends SettingsEvent {
  final bool value;

  ApplyBiometricsEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class DeleteBiometricsRegisterEvent extends SettingsEvent {
  @override
  List<Object?> get props => [];
}
