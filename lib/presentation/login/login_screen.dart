import 'dart:developer';

import 'package:chatapp/auth/bloc/auth_bloc.dart';
import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/components/custom_textformfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;

  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SignInLoadingState) {
                showDialog(
                    context: context,
                    builder: (context) => const Center(
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator())),
                    barrierDismissible: false);
              }
              if (state is SignInSuccessState) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.successMsg)));
                log('logged in ${state.userCredential}');
              }
              if (state is SignInFailedState) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMsg!)));
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Column(
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
                      'Welcome to Hamro ChatApp',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomTextFormField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'required*';
                          }
                          return null;
                        },
                        controller: _emailController,
                        hintText: 'Email',
                        obscure: false),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'required*';
                          }
                          return null;
                        },
                        controller: _passwordController,
                        hintText: 'password',
                        obscure: false),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomButton(
                      title: 'Login',
                      onPressed: () {
                        context.read<AuthBloc>().add(SignInButtonPressed(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim()));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Dont\'t have an account? ',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onTap,
                          text: 'Register Now',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary))
                    ]))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
