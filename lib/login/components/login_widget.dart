import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_auth/enum/biometric_enum.dart';
import 'package:flutter_local_auth/login/bloc/login_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isError) {
          Fluttertoast.showToast(
              msg: 'User/Password are not valid',
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              timeInSecForIosWeb: 2,
              fontSize: 16.0);
        } else if (state.status.isSuccess) {
          Navigator.of(context).pushNamed('/home');
        }
      },
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) => context
                          .read<LoginBloc>()
                          .add(ChangeUsernameEvent(value: value)),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Username',
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.account_circle_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) => context
                          .read<LoginBloc>()
                          .add(ChangePasswordEvent(value: value)),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.password),
                        hintText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _canSubmit(state)
                          ? () => context.read<LoginBloc>().add(SubmitEvent())
                          : null,
                      child: const Text('Submit'),
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(200, 25)),
                        backgroundColor: MaterialStateProperty.all(
                            _canSubmit(state) && !state.status.isLoading
                                ? Colors.green
                                : Colors.grey[100]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (state.status.isLoading) ...[
                      const LinearProgressIndicator(
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SliverVisibility(
              visible: describeEnum(state.biometric) !=
                  describeEnum(BiometricEnum.NONE),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      describeEnum(state.biometric) ==
                              describeEnum(BiometricEnum.FACE_ID)
                          ? Icons.account_box_outlined
                          : Icons.fingerprint_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => context
                          .read<LoginBloc>()
                          .add(LoginWithBiometricsEvent()),
                      child: Text(
                        describeEnum(state.biometric) ==
                                describeEnum(BiometricEnum.FACE_ID)
                            ? 'Access with Face ID'
                            : describeEnum(state.biometric) ==
                                    describeEnum(BiometricEnum.TOUCH_ID)
                                ? 'Access with Touch ID'
                                : 'Access with Fingerprint',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _canSubmit(LoginState state) {
    return state.username.isNotEmpty && state.password.isNotEmpty;
  }
}
