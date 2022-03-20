import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_auth/constants/constants.dart';
import 'package:flutter_local_auth/enum/biometric_enum.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoadBiometricsEvent>(_mapLoadBiometricsEventToState);
    on<ChangeUsernameEvent>(_mapChangeUsernameEventToState);
    on<ChangePasswordEvent>(_mapChangePasswordEventToState);
    on<SubmitEvent>(_mapSubmitEventToState);
    on<LoginWithBiometricsEvent>(_mapLoginWithBiometricsEventToState);
  }

  void _mapLoadBiometricsEventToState(
      LoadBiometricsEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final prefs = await SharedPreferences.getInstance();
    BiometricEnum bio = BiometricEnum.NONE;
    if (prefs.containsKey(Constants.accessBiometric)) {
      final String? bioSelected = prefs.getString(Constants.accessBiometric);
      if (bioSelected! == describeEnum(BiometricEnum.FACE_ID)) {
        bio = BiometricEnum.FACE_ID;
      } else if (bioSelected == describeEnum(BiometricEnum.TOUCH_ID)) {
        bio = BiometricEnum.TOUCH_ID;
      } else if (bioSelected == describeEnum(BiometricEnum.FINGERPRINT)) {
        bio = BiometricEnum.FINGERPRINT;
      }
    }

    emit(state.copyWith(status: LoginStatus.initial, biometric: bio));
  }

  void _mapChangeUsernameEventToState(
      ChangeUsernameEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      status: LoginStatus.initial,
      username: event.value,
    ));
  }

  void _mapChangePasswordEventToState(
      ChangePasswordEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      status: LoginStatus.initial,
      password: event.value,
    ));
  }

  void _mapSubmitEventToState(
      SubmitEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    await Future.delayed(const Duration(seconds: 2));
    if (state.username == 'user1' && state.password == 'pass') {
      emit(state.copyWith(status: LoginStatus.success));
    } else {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  void _mapLoginWithBiometricsEventToState(
      LoginWithBiometricsEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    await Future.delayed(const Duration(seconds: 1));
    var localAuth = LocalAuthentication();
    final bool auth = await localAuth.authenticate(localizedReason: '-');
    if (auth) {
      emit(state.copyWith(status: LoginStatus.success));
    } else {
      emit(state.copyWith(status: LoginStatus.errorBiometrics));
    }
  }
}
