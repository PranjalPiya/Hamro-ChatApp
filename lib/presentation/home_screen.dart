import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/auth/bloc/auth_bloc.dart';
import 'package:chatapp/components/custom_logout.dart';
import 'package:chatapp/presentation/chats/bloc/chat_bloc.dart';
import 'package:chatapp/presentation/chats/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  void logout() {
    final auth = AuthServices();
    auth.logout();
  }

  //get instance of auth service
  final authService = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                logoutComponent(
                  context: context,
                  onPressed: () {
                    logout();
                    Navigator.of(context).pop();
                  },
                );
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: BlocProvider(
        create: (context) => ChatBloc(ChatServices())..add(LoadAllUsersEvent()),
        child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
          if (state is GetAllUserLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetAllUserFailedState) {
            return Center(
              child: Text(state.errMsg),
            );
          }
          if (state is GetAllUserSuccessState) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return usersDisplayTile(context: context, user: user);
              },
            );
          }
          return const SizedBox();
        }),
      ),
    );
  }

  Widget usersDisplayTile({BuildContext? context, Map<String, dynamic>? user}) {
    if (user!['email'] != authService.getCurrentUser()!.email) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context!).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Icon(
              Icons.person,
              size: 24,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            title: Text('${user['email']}'),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
