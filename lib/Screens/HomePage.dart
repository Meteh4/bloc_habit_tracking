import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habittin/Blocs/Auth_Bloc/auth_bloc.dart';
import 'package:habittin/Screens/habitlist.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return Text('Welcome, ${state.user?.displayName}!');
            } else {
              return const Text('Welcome, you are In!');
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(const AuthenticationUserChanged(null));
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: HabitList(),
    );
  }
}
