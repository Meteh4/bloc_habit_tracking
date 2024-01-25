
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habittin/Blocs/Auth_Bloc/auth_bloc.dart';
import 'package:habittin/Blocs/Login_Bloc/login_bloc.dart';
import 'package:habittin/Screens/HomePage.dart';
import 'package:habittin/Screens/LoginPage.dart';


class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Firebase Auth',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
              background: Colors.white,
              onBackground: Colors.black,
              primary: Color(0xff335fa1),
              onPrimary: Colors.black,
              secondary: Color.fromRGBO(107, 141, 192, 1.0),
              onSecondary: Colors.white,
              tertiary: Color.fromRGBO(255, 204, 128, 1),
              error: Colors.red,
              outline: Color(0xFF424242)
          ),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if(state.status == AuthenticationStatus.authenticated) {
                return BlocProvider(
                  create: (context) => SignInBloc(
                      userRepository: context.read<AuthenticationBloc>().userRepository
                  ),
                  child: const HomeScreen(),
                );
              } else {
                return LoginScreen();
              }
            }
        )
    );
  }
}