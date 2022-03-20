part of 'settings_bloc.dart';

enum SettingsStatus {
  initial,
  success,
  error,
  loading,
  checked,
  successBiometric
}

extension SettingsStatusX on SettingsStatus {
  bool get isInitial => this == SettingsStatus.initial;

  bool get isSuccess => this == SettingsStatus.success;

  bool get isSuccessBiometric => this == SettingsStatus.successBiometric;

  bool get isError => this == SettingsStatus.error;

  bool get isLoading => this == SettingsStatus.loading;

  bool get isChecked => this == SettingsStatus.checked;
}

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    BiometricEnum? biometric,
  }) : biometric = biometric ?? BiometricEnum.NONE;

  final BiometricEnum biometric;
  final SettingsStatus status;

  @override
  List<Object?> get props => [status, biometric];

  SettingsState copyWith({
    BiometricEnum? biometric,
    SettingsStatus? status,
  }) {
    return SettingsState(
      biometric: biometric ?? this.biometric,
      status: status ?? this.status,
    );
  }
}
