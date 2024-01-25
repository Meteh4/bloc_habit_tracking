
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habittin/Blocs/Auth_Bloc/auth_bloc.dart';
import 'package:habittin/Blocs/Google_Signin/google_sign_in_bloc.dart';
import 'package:habittin/Blocs/Login_Bloc/login_bloc.dart';
import 'package:habittin/Screens/ForgotPasswordPage.dart';
import 'package:habittin/Screens/RegisterPage.dart';
import 'package:habittin/Widgets/AuthEmail.dart';
import 'package:habittin/Widgets/AuthSVG.dart';
import 'package:habittin/Widgets/LottieAuthBackground.dart';
import 'package:line_icons/line_icons.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(
              userRepository: context.read<AuthenticationBloc>().userRepository,
            ),
          ),
          BlocProvider<GoogleSignInBloc>(
            create: (context) => GoogleSignInBloc(
              userRepository: context.read<AuthenticationBloc>().userRepository,
            ),
          ),
        ],
        child: const SingleChildScrollView(
            child: Login_Form()
        ),
      ),
    );
  }
}



class Login_Form extends StatefulWidget {
  const Login_Form({super.key});

  @override
  State<Login_Form> createState() => _Login_FormState();
}

class _Login_FormState extends State<Login_Form> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = Icons.visibility;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if(state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });
        } else if(state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if(state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid email or password';
          });
        }
      },
      child: Form(
          key: _formKey,
          child: Stack(
            children: [
              const LottieAuthBackground(),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 50, 15, 15),
                      child: SizedBox(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: LoginSvg(),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white60,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: MyTextField(
                                  controller: emailController,
                                  hintText: 'Email',
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: const Icon(Icons.alternate_email_outlined,
                                    color:Color(0xFF395886),
                                  ),
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


                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: MyTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                prefixIcon: const Icon(Icons.password_rounded,
                                color: Color(0xFF395886),
                                ),
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$').hasMatch(val)) {
                                    return 'Please enter a valid password';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  color: const Color(0xFF395886),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                      if(obscurePassword) {
                                        iconPassword = Icons.visibility_rounded;
                                      } else {
                                        iconPassword = Icons.visibility_off_rounded;
                                      }
                                    });
                                  },
                                  icon: Icon(iconPassword),
                                ),
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 20, 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ForgotPasswordScreen(),),
                                      );
                                    },
                                    child: GradientText(
                                      'Forgot Password ?',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                      ),
                                      textAlign: TextAlign.end,
                                      colors: const [
                                        Color(0xFF395886),
                                        Color(0xFF638ECB),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            !signInRequired

                                ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: FloatingActionButton.extended(
                                        elevation: 0,
                                        backgroundColor: Colors.white60,
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            context.read<SignInBloc>().add(SignInRequired(
                                                emailController.text,
                                                passwordController.text)
                                            );
                                          }
                                        },
                                        label: const Text(
                                          "login",
                                          style: TextStyle(
                                            color: Color(0xff395886),
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.login_rounded,
                                          color: Color(0xFF395886),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : const CircularProgressIndicator(),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Divider(
                                    color: Color(0xFF395886),
                                    thickness: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: GradientText(
                                      'New to App ? Register',
                                      colors: const [
                                        Color(0xFF395886),
                                        Color(0xFF638ECB),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Color(0xFF395886),
                                    thickness: 5,
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: FloatingActionButton.extended(
                                          elevation: 0,
                                          backgroundColor: Colors.white60,
                                          onPressed: () {
                                            context.read<GoogleSignInBloc>().add(GoogleSignInRequested());
                                          },
                                          label: const Text(
                                            "Login With Google",
                                            style: TextStyle(
                                              color: Color(0xff395886),
                                            ),
                                          ),
                                          icon: const Icon(
                                            LineIcons.googlePlay,
                                            color: Color(0xFF395886),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
