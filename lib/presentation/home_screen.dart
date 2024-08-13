import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/auth/bloc/auth_bloc.dart';
import 'package:chatapp/components/custom_logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void logout() {
    final auth = AuthServices();
    auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                logoutComponent(
                  context: context,
                  onPressed: () {
                    logout();
                    Navigator.of(context).pop();
                  },
                );
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
    );
  }
}
