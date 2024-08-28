import 'dart:developer';

import 'package:chatapp/presentation/chats/bloc/chat_bloc.dart';
import 'package:chatapp/presentation/chats/chat_services.dart';
import 'package:chatapp/theme/bloc/theme_cubit.dart';
import 'package:chatapp/theme/dark_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Widget showUsersMessages({
  BuildContext? context,
  String? receiverId,
  // String? senderId,
  ScrollController? scrollController,
  FirebaseAuth? auth,
}) {
  final bool isDarkMode = context!.watch<ThemeCubit>().currentTheme == darkMode;
  return BlocProvider(
    create: (context) => ChatBloc(ChatServices())
      ..add(GetMessageEvent(
          receiverId: receiverId!, senderId: auth!.currentUser!.uid)),
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
            controller: scrollController,
            shrinkWrap: true,
            itemCount: state.getMsg.length,
            itemBuilder: (context, index) {
              final getMsgDetail = state.getMsg[index];
              // log(readDate(getMsgDetail['timestamp']));
              bool isCurrentUser =
                  getMsgDetail['senderId'] == auth!.currentUser!.uid;

              return Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isCurrentUser
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary),
                    child: Text(
                      '${getMsgDetail['message']}',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
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

String readDate(Timestamp dateTime) {
  DateTime date = dateTime.toDate(); // Convert Timestamp to DateTime
  DateTime now = DateTime.now(); // Get the current date and time

  // Check if the date is today
  if (DateFormat('yyyy-MM-dd').format(date) ==
      DateFormat('yyyy-MM-dd').format(now)) {
    // If it's today, return the time in '11:00 AM/PM' format
    return DateFormat('hh:mm a').format(date);
  }

  // // Check if the date is yesterday
  // if (DateFormat('yyyy-MM-dd').format(date) ==
  //     DateFormat('yyyy-MM-dd')
  //         .format(now.subtract(const Duration(days: 1)))) {
  //   // If it's yesterday, return 'Yesterday 10:00 AM/PM'
  //   return 'Yesterday ${DateFormat('hh:mm a').format(date)}';
  // }

  // If it's a previous date, return the day and time in 'SUN 10:00 AM/PM' format
  return DateFormat('EEE hh:mm a').format(date);
}
