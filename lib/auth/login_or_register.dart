import 'package:chatapp/presentation/login_screen.dart';
import 'package:chatapp/presentation/register_screen.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;

  void setShowLogin() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!showLogin) {
      return RegisterScreen(
        onTap: setShowLogin,
      );
    } else {
      return LoginScreen(
        onTap: setShowLogin,
      );
    }
  }
}
