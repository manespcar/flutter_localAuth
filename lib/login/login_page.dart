import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_auth/login/bloc/login_bloc.dart';
import 'package:flutter_local_auth/login/components/login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc()..add(LoadBiometricsEvent()),
          child: const LoginWidget(),
        ),
      ),
    );
  }
}
