import 'package:chatapp/theme/bloc/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S E T T I N G'),
      ),
      body: Column(
        children: [
          BlocBuilder<ThemeCubit, bool>(
            builder: (context, state) {
              return ListTile(
                title: const Text('Dark Mode'),
                trailing: CupertinoSwitch(
                  value: context.watch<ThemeCubit>().state,
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
