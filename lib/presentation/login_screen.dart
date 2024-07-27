import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/components/custom_textformfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                'Welcome to Hamro ChatApp',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomTextFormField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscure: false),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                  controller: _passwordController,
                  hintText: 'password',
                  obscure: false),
              const SizedBox(
                height: 50,
              ),
              CustomButton(
                title: 'Login',
                onPressed: () {},
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
                    recognizer: TapGestureRecognizer()..onTap = widget.onTap,
                    text: 'Register Now',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary))
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
