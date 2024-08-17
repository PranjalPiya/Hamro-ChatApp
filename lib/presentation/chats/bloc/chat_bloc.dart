import 'package:bloc/bloc.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/presentation/chats/chat_services.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatServices chatServices;
  ChatBloc(this.chatServices) : super(ChatInitial()) {
    on<LoadAllUsersEvent>(getAllUsers);
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
}
