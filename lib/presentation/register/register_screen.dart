import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/components/custom_textformfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
          child: Form(
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
                    } else if (_passwordController !=
                        _confirmPasswordController) {
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
                      recognizer: TapGestureRecognizer()..onTap = widget.onTap,
                      text: 'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary))
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
