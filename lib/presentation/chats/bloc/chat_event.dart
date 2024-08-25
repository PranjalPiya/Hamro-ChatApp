part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class LoadAllUsersEvent extends ChatEvent {}

//send message
final class SendMessageEvent extends ChatEvent {
  final String receiverId;
  final String newMessage;

  const SendMessageEvent({required this.receiverId, required this.newMessage});
  @override
  List<Object> get props => [receiverId, newMessage];
}
