import 'package:chatapp/components/custom_textformfield.dart';
import 'package:chatapp/presentation/chats/bloc/chat_bloc.dart';
import 'package:chatapp/theme/bloc/theme_cubit.dart';
import 'package:chatapp/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget messageSendingContainer(
    {String? receiverId,
    TextEditingController? sendMessageController,
    Function(String)? onChanged,
    BuildContext? context}) {
  final bool isDarkMode = context!.watch<ThemeCubit>().currentTheme == darkMode;
  return BlocBuilder<ChatBloc, ChatState>(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 7),
        child: Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                  focusNode: focusNode,
                  onChanged: onChanged,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'required*';
                    }
                    return null;
                  },
                  controller: sendMessageController!,
                  hintText: 'Send a Message...',
                  obscure: false),
            ),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: sendMessageController.text.isEmpty
                      ? Theme.of(context).colorScheme.primary
                      : Colors.green),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_upward,
                  size: 25,
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.secondary,
                ),
                onPressed: sendMessageController.text.isEmpty
                    ? null
                    : () {
                        context.read<ChatBloc>().add(SendMessageEvent(
                            receiverId: receiverId!,
                            newMessage: sendMessageController.text.trim()));
                        sendMessageController.clear();
                      },
              ),
            ),
          ],
        ),
      );
    },
  );
}
