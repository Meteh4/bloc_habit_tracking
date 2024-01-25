// forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habittin/Blocs/Auth_Bloc/auth_bloc.dart';
import 'package:habittin/Blocs/Forgot_Password_Bloc/forgot_password_bloc.dart';
import 'package:habittin/Widgets/AuthEmail.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ForgotPasswordBloc>(
        create: (context) => ForgotPasswordBloc(
          userRepository: context.read<AuthenticationBloc>().userRepository,
        ),
        child: const ForgotPasswordForm(),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final emailController = TextEditingController();
  late ForgotPasswordBloc _forgotPasswordBloc;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          // Handle success, show a success message or navigate to a success screen
        } else if (state is ForgotPasswordFailure) {
          setState(() {
            _errorMsg = 'Invalid email';
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.alternate_email_outlined),
                  errorMsg: _errorMsg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _forgotPasswordBloc.add(
                  ForgotPasswordRequested(emailController.text),
                );
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),

    );
  }
}
