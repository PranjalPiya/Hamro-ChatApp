// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/components/custom_textformfield.dart';
import 'package:chatapp/presentation/chats/bloc/chat_bloc.dart';
import 'package:chatapp/presentation/chats/chat_services.dart';
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
      body: BlocProvider(
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
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.getMsg.length,
                    itemBuilder: (context, index) {
                      final getMsgDetail = state.getMsg[index];
                      return Text('${getMsgDetail['message']}');
                    },
                  ),
                  messageSendingContainer(
                      receiverId: widget.receiverId,
                      sendMessageController: _sendMsgController),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget hehe() {
    return StreamBuilder(
      stream: chatService.getMessages(userId: '', otherUserId: ''),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('waiting');
        }
        return ListView(
            children: snapshot.data!.docs.map((e) {
          final data = e.data() as Map<String, dynamic>;
          return Text('${data['message']}');
        }).toList());
      },
    );
  }
}

Widget messageSendingContainer(
    {String? receiverId, TextEditingController? sendMessageController}) {
  return BlocListener<ChatBloc, ChatState>(
    listener: (context, state) {
      if (state is SendMessageSuccessState) {
        log(state.successMsg);
      }
      if (state is SendMessageFailedState) {
        log(state.errMsg);
      }
    },
    child: BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                child: CustomTextFormField(
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
              IconButton(
                icon: Icon(
                  Icons.arrow_upward,
                  size: 25,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                onPressed: () {
                  if (sendMessageController.text.trim().isNotEmpty) {
                    context.read<ChatBloc>().add(SendMessageEvent(
                        receiverId: receiverId!,
                        newMessage: sendMessageController.text.trim()));
                  } else {
                    return;
                  }
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}
