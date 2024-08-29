// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:chatapp/presentation/chats/chat_services.dart';
import 'package:chatapp/presentation/chats/widgets/send_message.dart';
import 'package:chatapp/presentation/chats/widgets/show_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final FocusNode focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => scrollDown(),
      );
    });

    //
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

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
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
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
              child: showUsersMessages(
                  auth: auth,
                  context: context,
                  receiverId: widget.receiverId,
                  scrollController: _scrollController),
            ),
          ),
          messageSendingContainer(
              scrollController: _scrollController,
              context: context,
              onChanged: (p0) {
                setState(() {
                  _sendMsgController.text = p0;
                });
              },
              receiverId: widget.receiverId,
              sendMessageController: _sendMsgController),
        ],
      ),
    );
  }

  // Widget showUsersMessages() {
  //   final bool isDarkMode =
  //       context.watch<ThemeCubit>().currentTheme == darkMode;
  //   return BlocProvider(
  //     create: (context) => ChatBloc(ChatServices())
  //       ..add(GetMessageEvent(
  //           receiverId: widget.receiverId!, senderId: auth.currentUser!.uid)),
  //     child: BlocBuilder<ChatBloc, ChatState>(
  //       builder: (context, state) {
  //         if (state is GetMessageLoadingState) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //         if (state is GetMessageFailedState) {
  //           log(state.errMsg);
  //           return Center(
  //             child: Text(state.errMsg),
  //           );
  //         }
  //         if (state is GetMessageSuccessState) {
  //           return ListView.builder(
  //             controller: _scrollController,
  //             shrinkWrap: true,
  //             itemCount: state.getMsg.length,
  //             itemBuilder: (context, index) {
  //               final getMsgDetail = state.getMsg[index];
  //               // log(readDate(getMsgDetail['timestamp']));
  //               bool isCurrentUser =
  //                   getMsgDetail['senderId'] == auth.currentUser!.uid;

  //               return Column(
  //                 crossAxisAlignment: isCurrentUser
  //                     ? CrossAxisAlignment.end
  //                     : CrossAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 15, vertical: 8),
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                         color: isCurrentUser
  //                             ? Colors.green
  //                             : Theme.of(context).colorScheme.primary),
  //                     child: Text(
  //                       '${getMsgDetail['message']}',
  //                       style: TextStyle(
  //                           // fontWeight: FontWeight.bold,
  //                           color: isDarkMode
  //                               ? Theme.of(context).colorScheme.inversePrimary
  //                               : Theme.of(context).colorScheme.tertiary),
  //                     ),
  //                   ),
  //                   Text(
  //                     readDate(getMsgDetail['timestamp']),
  //                     style: TextStyle(
  //                         color: Theme.of(context).colorScheme.primary,
  //                         fontSize: 12),
  //                   ),
  //                   const SizedBox(
  //                     height: 7,
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         }
  //         return const SizedBox();
  //       },
  //     ),
  //   );
  // }
}
