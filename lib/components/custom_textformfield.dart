import 'package:chatapp/theme/bloc/theme_cubit.dart';
import 'package:chatapp/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final focusNode = FocusNode();

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  const CustomTextFormField(
      {super.key,
      this.onChanged,
      required this.controller,
      required this.hintText,
      required this.validator,
      required this.obscure});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.read<ThemeCubit>().currentTheme == darkMode;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          controller: controller,
          obscureText: obscure,
          validator: validator,
          maxLines: null, // Allows the text field to expand vertically
          minLines: 1, // Starts with a single line
          keyboardType: TextInputType.multiline,
          onChanged: onChanged,
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
                color: isDarkMode
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.primary),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.inversePrimary
                        : Theme.of(context).colorScheme.tertiary)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.inversePrimary
                        : Theme.of(context).colorScheme.tertiary)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.inversePrimary
                        : Theme.of(context).colorScheme.primary)),
          ),
        ));
  }
}
