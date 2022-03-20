part of 'login_bloc.dart';

enum LoginStatus { initial, success, error, loading, errorBiometrics }

extension LoginStatusX on LoginStatus {
  bool get isInitial => this == LoginStatus.initial;

  bool get isSuccess => this == LoginStatus.success;

  bool get isError => this == LoginStatus.error;

  bool get isErrorBiometrics => this == LoginStatus.errorBiometrics;

  bool get isLoading => this == LoginStatus.loading;
}

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    String? username,
    String? password,
    BiometricEnum? biometric,
  })  : username = username ?? '',
        password = password ?? '',
        biometric = biometric ?? BiometricEnum.NONE;

  final String username;
  final String password;
  final BiometricEnum biometric;
  final LoginStatus status;

  @override
  List<Object?> get props => [status, username, password, biometric];

  LoginState copyWith({
    String? username,
    String? password,
    BiometricEnum? biometric,
    LoginStatus? status,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      biometric: biometric ?? this.biometric,
      status: status ?? this.status,
    );
  }
}
