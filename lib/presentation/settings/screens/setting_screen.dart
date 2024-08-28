import 'package:chatapp/theme/bloc/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'S E T T I N G',
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w400),
        ),
        leading: InkWell(
          radius: 20,
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
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
