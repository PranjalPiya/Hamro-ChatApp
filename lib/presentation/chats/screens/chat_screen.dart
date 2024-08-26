// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/components/custom_textformfield.dart';
import 'package:chatapp/presentation/chats/bloc/chat_bloc.dart';
import 'package:chatapp/presentation/chats/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    // TODO: implement dispose
    _sendMsgController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.receiverUsername}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: showUsersMessages(),
          ),
          messageSendingContainer(
              receiverId: widget.receiverId,
              sendMessageController: _sendMsgController),
        ],
      ),
    );
  }

  Widget showUsersMessages() {
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
                // log('$Date');
                bool isCurrentUser =
                    getMsgDetail['senderId'] == auth.currentUser!.uid;
                final alignment = isCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft;
                return Column(
                  crossAxisAlignment: isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${getMsgDetail['message']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                        decoration: const BoxDecoration(color: Colors.red),
                        child: Text('${getMsgDetail['timestamp']}'))
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
                    color: Theme.of(context).colorScheme.secondary,
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
