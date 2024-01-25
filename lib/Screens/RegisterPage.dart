import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habittin/Blocs/Auth_Bloc/auth_bloc.dart';
import 'package:habittin/Blocs/Register_Bloc/register_bloc.dart';
import 'package:habittin/Widgets/AuthEmail.dart';
import 'package:habittin/Widgets/AuthSVG.dart';
import 'package:habittin/Widgets/LottieAuthBackground.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
            userRepository: context.read<AuthenticationBloc>().userRepository
        ),
        child: const Register_Form(),
      ),
    );
  }
}


class Register_Form extends StatefulWidget {
  const Register_Form({super.key});

  @override
  State<Register_Form> createState() => _Register_FormState();
}

class _Register_FormState extends State<Register_Form> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = Icons.visibility;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if(state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
          // Navigator.pop(context);
        } else if(state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        }  else if(state is SignUpFailure) {
          return;
        }
      },
      child: SingleChildScrollView(
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
                          child: RegisterSvg(),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white60,
                      ),
                      child:Padding(
                        padding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextField(
                                  controller: emailController,
                                  hintText: 'Email',
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: const Icon(Icons.alternate_email_outlined,
                                    color: Color(0xFF395886),
                                  ),
                                  validator: (val) {
                                    if(val!.isEmpty) {
                                      return 'Please fill in this field';
                                    } else if(!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  }
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextField(
                                  controller: passwordController,
                                  hintText: 'Password',
                                  obscureText: obscurePassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  prefixIcon: const Icon(Icons.password_rounded,
                                    color:Color(0xFF395886),
                                  ),
                                  onChanged: (val) {
                                    if(val!.contains(RegExp(r'[A-Z]'))) {
                                      setState(() {
                                        containsUpperCase = true;
                                      });
                                    } else {
                                      setState(() {
                                        containsUpperCase = false;
                                      });
                                    }
                                    if(val.contains(RegExp(r'[a-z]'))) {
                                      setState(() {
                                        containsLowerCase = true;
                                      });
                                    } else {
                                      setState(() {
                                        containsLowerCase = false;
                                      });
                                    }
                                    if(val.contains(RegExp(r'[0-9]'))) {
                                      setState(() {
                                        containsNumber = true;
                                      });
                                    } else {
                                      setState(() {
                                        containsNumber = false;
                                      });
                                    }
                                    if(val.contains(RegExp(r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                                      setState(() {
                                        containsSpecialChar = true;
                                      });
                                    } else {
                                      setState(() {
                                        containsSpecialChar = false;
                                      });
                                    }
                                    if(val.length >= 8) {
                                      setState(() {
                                        contains8Length = true;
                                      });
                                    } else {
                                      setState(() {
                                        contains8Length = false;
                                      });
                                    }
                                    return null;
                                  },
                                  suffixIcon: IconButton(
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
                                    icon: Icon(iconPassword,
                                      color:const Color(0xFF395886),
                                    ),
                                  ),
                                  validator: (val) {
                                    if(val!.isEmpty) {
                                      return 'Please fill in this field';
                                    } else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$').hasMatch(val)) {
                                      return 'Please enter a valid password';
                                    }
                                    return null;
                                  }
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(containsUpperCase
                                            ? LineIcons.checkCircleAlt
                                            : LineIcons.exclamationCircle,
                                            color: containsUpperCase
                                                ? Colors.green
                                                : Colors.red),
                                        Text(
                                          "1 Uppercase",
                                          style: TextStyle(
                                              color: containsUpperCase
                                                  ? Colors.green
                                                  : Colors.red
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(containsLowerCase
                                            ? LineIcons.checkCircleAlt
                                            : LineIcons.exclamationCircle,
                                            color: containsLowerCase
                                                ? Colors.green
                                                : Colors.red),
                                        Text(
                                          "1 Lowercase",
                                          style: TextStyle(
                                              color: containsLowerCase
                                                  ? Colors.green
                                                  : Colors.red
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(containsNumber
                                            ? LineIcons.checkCircleAlt
                                            : LineIcons.exclamationCircle,
                                            color: containsNumber
                                                ? Colors.green
                                                : Colors.red),
                                        Text(
                                          "1 Number",
                                          style: TextStyle(
                                              color: containsNumber
                                                  ? Colors.green
                                                  : Colors.red
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Row(
                                        children: [
                                          Icon(containsSpecialChar
                                              ? LineIcons.checkCircleAlt
                                              : LineIcons.exclamationCircle,
                                              color: containsSpecialChar
                                                  ? Colors.green
                                                  : Colors.red),
                                          Text(
                                            "1 Special Character",
                                            style: TextStyle(
                                                color: containsSpecialChar
                                                    ? Colors.green
                                                    : Colors.red
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(contains8Length
                                            ? LineIcons.checkCircleAlt
                                            : LineIcons.exclamationCircle,
                                            color: contains8Length
                                                ? Colors.green
                                                : Colors.red),
                                        Text(
                                          "8 Minimum Character",
                                          style: TextStyle(
                                              color: contains8Length
                                                  ? Colors.green
                                                  : Colors.red
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextField(
                                  controller: nameController,
                                  hintText: 'Name',
                                  obscureText: false,
                                  keyboardType: TextInputType.name,
                                  prefixIcon: const Icon(LineIcons.userCircleAlt,
                                    color: Color(0xFF395886),
                                  ),
                                  validator: (val) {
                                    if(val!.isEmpty) {
                                      return 'Please fill in this field';
                                    } else if(val.length > 30) {
                                      return 'Name too long';
                                    }
                                    return null;
                                  }
                              ),
                            ),

                            !signUpRequired

                                ? Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                            if (_formKey.currentState!.validate()) {
                                              MyUser myUser = MyUser.empty;
                                              myUser = myUser.copyWith(
                                                email: emailController.text,
                                                name: nameController.text,
                                              );
                                              setState(() {
                                                context.read<SignUpBloc>().add(
                                                    SignUpRequired(
                                                        myUser,
                                                        passwordController.text
                                                    )
                                                );
                                              });
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
                            ),
                                )
                                : const CircularProgressIndicator(),


                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}