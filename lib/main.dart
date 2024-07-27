import 'package:chatapp/auth/login_or_register.dart';
import 'package:chatapp/presentation/login_screen.dart';
import 'package:chatapp/presentation/register_screen.dart';
import 'package:chatapp/theme/light_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightMode,
      home: const LoginOrRegister(),
    );
  }
}
