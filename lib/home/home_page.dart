import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_auth/bloc/settings_bloc.dart';
import 'package:flutter_local_auth/home/components/home_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc()..add(CheckBiometricsEvent()),
      child: Scaffold(
        backgroundColor: Colors.blueAccent.shade100,
        body: const Padding(
          padding: EdgeInsets.all(40),
          child: HomeWidget(),
        ),
      ),
    );
  }
}
