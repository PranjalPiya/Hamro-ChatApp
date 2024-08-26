// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/components/custom_textformfield.dart';
import 'package:chatapp/presentation/chats/bloc/chat_bloc.dart';
import 'package:chatapp/presentation/chats/chat_services.dart';
import 'package:chatapp/theme/bloc/theme_cubit.dart';
import 'package:chatapp/theme/dark_theme.dart';
import 'package:chatapp/theme/light_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String? receiverEmail;
  final String? receiverUsername;
  final String? receiverId;
  const ChatScreen({
    super.key,
    this.receiverEmail,
    this.receiverUsername,
    this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _sendMsgController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final chatService = ChatServices();

  @override
  void dispose() {
    _sendMsgController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: InkWell(
          radius: 20,
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            // color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        title: Text(
          '${widget.receiverUsername}'.toUpperCase(),
          style: const TextStyle(
              // color: Theme.of(context).colorScheme.tertiary,
              letterSpacing: 2,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: showUsersMessages(),
            ),
          ),
          messageSendingContainer(
              receiverId: widget.receiverId,
              sendMessageController: _sendMsgController),
        ],
      ),
    );
  }

  String readDate(Timestamp dateTime) {
    DateTime date = dateTime.toDate(); // Convert Timestamp to DateTime
    DateTime now = DateTime.now(); // Get the current date and time

    // Check if the date is today
    if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(now)) {
      // If it's today, return the time in '11:00 AM/PM' format
      return DateFormat('hh:mm a').format(date);
    }

    // Check if the date is yesterday
    if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 1)))) {
      // If it's yesterday, return 'Yesterday 10:00 AM/PM'
      return 'Yesterday ${DateFormat('hh:mm a').format(date)}';
    }

    // If it's a previous date, return the day and time in 'SUN 10:00 AM/PM' format
    return DateFormat('EEE hh:mm a').format(date);
  }

  Widget showUsersMessages() {
    final bool isDarkMode =
        context.watch<ThemeCubit>().currentTheme == darkMode;
    return BlocProvider(
      create: (context) => ChatBloc(ChatServices())
        ..add(GetMessageEvent(
            receiverId: widget.receiverId!, senderId: auth.currentUser!.uid)),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is GetMessageLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetMessageFailedState) {
            log(state.errMsg);
            return Center(
              child: Text(state.errMsg),
            );
          }
          if (state is GetMessageSuccessState) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.getMsg.length,
              itemBuilder: (context, index) {
                final getMsgDetail = state.getMsg[index];
                // log(readDate(getMsgDetail['timestamp']));
                bool isCurrentUser =
                    getMsgDetail['senderId'] == auth.currentUser!.uid;

                return Column(
                  crossAxisAlignment: isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isCurrentUser
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary),
                      child: Text(
                        '${getMsgDetail['message']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Theme.of(context).colorScheme.inversePrimary
                                : Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                    Text(
                      readDate(getMsgDetail['timestamp']),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                  ],
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget messageSendingContainer(
      {String? receiverId, TextEditingController? sendMessageController}) {
    final bool isDarkMode =
        context.watch<ThemeCubit>().currentTheme == darkMode;
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 7),
          child: Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                    onChanged: (p0) {
                      setState(() {
                        sendMessageController.text = p0;
                      });
                    },
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
}
