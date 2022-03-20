import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_auth/bloc/settings_bloc.dart';
import 'package:flutter_local_auth/enum/biometric_enum.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state.status.isError) {
          Navigator.of(context).pushReplacementNamed('/');
        } else if (state.status.isSuccessBiometric) {
          Navigator.of(context).pop();
        } else if (state.status.isSuccess) {
          Navigator.of(context).pushReplacementNamed('/');
        } else if (state.status.isChecked &&
            state.biometric != BiometricEnum.NONE) {
          showDialog(
            context: context,
            builder: (_context) => CupertinoAlertDialog(
              content: Text(
                  'We have detected ${_getBiometricString(state.biometric)}.\nDo you want to do login the next time of this way?'),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => context
                      .read<SettingsBloc>()
                      .add(ApplyBiometricsEvent(value: false)),
                  child: const Text('No'),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => context
                      .read<SettingsBloc>()
                      .add(ApplyBiometricsEvent(value: true)),
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status.isSuccessBiometric ||
            state.status.isInitial ||
            describeEnum(state.biometric) == describeEnum(BiometricEnum.NONE)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed('/'),
                  child: const Text('Exit'),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(200, 25)),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                ),
                if (describeEnum(state.biometric) !=
                    describeEnum(BiometricEnum.NONE)) ...[
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => context
                        .read<SettingsBloc>()
                        .add(DeleteBiometricsRegisterEvent()),
                    child: const Text('Exit and delete biometrics data'),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(250, 25)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.amber.shade300),
                    ),
                  ),
                ]
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  String _getBiometricString(final BiometricEnum biometric) =>
      describeEnum(biometric) == describeEnum(BiometricEnum.FACE_ID)
          ? 'Face ID'
          : describeEnum(biometric) == describeEnum(BiometricEnum.TOUCH_ID)
              ? 'Touch ID'
              : 'Fingerprint';
}
