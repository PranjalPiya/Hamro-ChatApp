import 'package:bloc/bloc.dart';
import 'package:chatapp/core/auth/auth_services.dart';
import 'package:chatapp/presentation/chats/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatServices chatServices;
  ChatBloc(this.chatServices) : super(ChatInitial()) {
    on<LoadAllUsersEvent>(getAllUsers);
    on<SendMessageEvent>(sendMessage);
    on<GetMessageEvent>(getMessage);
  }

//bloc for getting all users
  Future<void> getAllUsers(
      LoadAllUsersEvent event, Emitter<ChatState> emitter) async {
    try {
      emitter.call(GetAllUserLoadingState());
      await emitter.forEach(chatServices.getAllUsers(),
          onError: (error, stackTrace) =>
              GetAllUserFailedState(errMsg: '$error'),
          onData: (List<Map<String, dynamic>> users) =>
              GetAllUserSuccessState(users: users));
    } catch (e) {
      emitter.call(GetAllUserFailedState(errMsg: '$e'));
    }
  }

  Future<void> sendMessage(
      SendMessageEvent event, Emitter<ChatState> emitter) async {
    try {
      emitter.call(SendMessageLoadingState());
      await chatServices.sendMessage(event.receiverId, event.newMessage);
      if (event.newMessage.isNotEmpty) {
        emitter.call(const SendMessageSuccessState(
            successMsg: 'Message sent successfully'));
      } else {
        emitter.call(
            const SendMessageFailedState(errMsg: 'Message failed to be sent'));
      }
    } catch (e) {
      emitter.call(SendMessageFailedState(errMsg: '$e'));
    }
  }

  Future<void> getMessage(
      GetMessageEvent event, Emitter<ChatState> emitter) async {
    try {
      emitter.call(GetMessageLoadingState());
      final Stream<QuerySnapshot> res = chatServices.getMessages(
          userId: event.receiverId, otherUserId: event.senderId);
      await emitter.forEach(res,
          onError: (error, stackTrace) =>
              GetMessageFailedState(errMsg: '$error'),
          onData: (QuerySnapshot snapshot) {
            // Map the QuerySnapshot to a list of message data
            List<Map<String, dynamic>> messages = snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            return GetMessageSuccessState(getMsg: messages);
          });
    } catch (e) {
      emitter.call(GetMessageFailedState(errMsg: '$e'));
    }
  }
}
