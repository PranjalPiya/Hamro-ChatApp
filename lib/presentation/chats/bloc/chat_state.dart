part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

//get all users state
final class GetAllUserLoadingState extends ChatState {}

final class GetAllUserSuccessState extends ChatState {
  final List<Map<String, dynamic>> users;

  const GetAllUserSuccessState({required this.users});
  @override
  List<Object> get props => [users];
}

final class GetAllUserFailedState extends ChatState {
  final String errMsg;

  const GetAllUserFailedState({required this.errMsg});

  @override
  List<Object> get props => [errMsg];
}

//
final class ChatInitial extends ChatState {}

final class ChatLoadingState extends ChatState {}

final class ChatSuccessState extends ChatState {}

final class ChatFailedState extends ChatState {}

//send chat message
final class SendMessageLoadingState extends ChatState {}

final class SendMessageSuccessState extends ChatState {
  final String successMsg;

  const SendMessageSuccessState({required this.successMsg});
  @override
  List<Object> get props => [successMsg];
}

final class SendMessageFailedState extends ChatState {
  final String errMsg;

  const SendMessageFailedState({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}

//get chat message
final class GetMessageLoadingState extends ChatState {}

final class GetMessageSuccessState extends ChatState {}

final class GetMessageFailedState extends ChatState {}
