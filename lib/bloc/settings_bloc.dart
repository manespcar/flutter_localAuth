import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_auth/constants/constants.dart';
import 'package:flutter_local_auth/enum/biometric_enum.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<CheckBiometricsEvent>(_mapCheckBiometricsEventToState);
    on<ApplyBiometricsEvent>(_mapApplyBiometricsEventToState);
    on<DeleteBiometricsRegisterEvent>(_mapDeleteBiometricsRegisterEventToState);
  }

  void _mapCheckBiometricsEventToState(
      CheckBiometricsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(Constants.accessBiometric)) {
      var localAuth = LocalAuthentication();
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      BiometricEnum bio = BiometricEnum.NONE;
      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          bio = BiometricEnum.FACE_ID;
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          bio = BiometricEnum.TOUCH_ID;
        }
      } else if (Platform.isAndroid &&
          availableBiometrics.contains(BiometricType.fingerprint)) {
        bio = BiometricEnum.FINGERPRINT;
      }

      emit(state.copyWith(
        status: SettingsStatus.checked,
        biometric: bio,
      ));
    } else {
      emit(state.copyWith(
        status: SettingsStatus.initial,
        biometric:
            _getBiometricParam(prefs.getString(Constants.accessBiometric)!),
      ));
    }
  }

  void _mapApplyBiometricsEventToState(
      ApplyBiometricsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final prefs = await SharedPreferences.getInstance();
    if (event.value) {
      var localAuth = LocalAuthentication();
      final bool auth = await localAuth.authenticate(localizedReason: '-');
      if (auth) {
        prefs.setString(
            Constants.accessBiometric, describeEnum(state.biometric));
        emit(state.copyWith(status: SettingsStatus.successBiometric));
      } else {
        emit(state.copyWith(status: SettingsStatus.error));
      }
    } else {
      emit(state.copyWith(
        status: SettingsStatus.successBiometric,
        biometric: BiometricEnum.NONE,
      ));
    }
  }

  void _mapDeleteBiometricsRegisterEventToState(
      DeleteBiometricsRegisterEvent event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    emit(state.copyWith(status: SettingsStatus.success));
  }

  BiometricEnum _getBiometricParam(String bio) {
    if (bio == describeEnum(BiometricEnum.FACE_ID)) {
      return BiometricEnum.FACE_ID;
    } else if (bio == describeEnum(BiometricEnum.TOUCH_ID)) {
      return BiometricEnum.TOUCH_ID;
    } else {
      return BiometricEnum.FINGERPRINT;
    }
  }
}
