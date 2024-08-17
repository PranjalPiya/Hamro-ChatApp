import 'dart:developer';

import 'package:chatapp/auth/bloc/auth_bloc.dart';
import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/components/custom_textformfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;

  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SignUpLoadingState) {
                showDialog(
                    context: context,
                    builder: (context) => const Center(
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator())),
                    barrierDismissible: false);
              }
              if (state is SignUpSuccessState) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${state.successMsg}')));
              }
              if (state is SignUpFailedState) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMsg!)));
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Form(
                  key: _globalKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message_rounded,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Please Register your account!',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomTextFormField(
                        controller: _emailController,
                        hintText: 'Email',
                        obscure: false,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: 'password',
                        obscure: false,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        hintText: 'confirm password',
                        obscure: false,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Cannot be empty';
                          } else if (_passwordController.text.trim() !=
                              _confirmPasswordController.text.trim()) {
                            return 'Password did not matched';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CustomButton(
                        title: 'Register',
                        onPressed: () {
                          if (_globalKey.currentState!.validate()) {
                            _globalKey.currentState!.save();
                            context.read<AuthBloc>().add(
                                  SignUpButtonPressed(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    confirmPassword:
                                        _confirmPasswordController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onTap,
                            text: 'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary))
                      ]))
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
