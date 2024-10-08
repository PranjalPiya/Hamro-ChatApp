import 'dart:developer';

import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/auth/bloc/auth_bloc.dart';
import 'package:chatapp/components/custom_logout.dart';
import 'package:chatapp/components/drawer.dart';
import 'package:chatapp/presentation/chats/bloc/chat_bloc.dart';
import 'package:chatapp/presentation/chats/chat_services.dart';
import 'package:chatapp/presentation/chats/screens/chat_screen.dart';
import 'package:chatapp/theme/bloc/theme_cubit.dart';
import 'package:chatapp/theme/dark_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final chatService = ChatServices();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        context.watch<ThemeCubit>().currentTheme == darkMode;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      drawer: appDrawer(
          context: context,
          onTap: () {
            // log('${auth.currentUser!.displayName}');
            logoutComponent(
              context: context,
              onPressed: () {
                logout();
                Navigator.of(context).pop();
              },
            );
          }),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isDarkMode
              ? Theme.of(context).colorScheme.inversePrimary
              : Theme.of(context).colorScheme.tertiary,
        ),
        backgroundColor: isDarkMode
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(
              color: isDarkMode
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w400),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChatScreen(
                      receiverUsername: '${user['username']}',
                      receiverEmail: '${user['email']}',
                      receiverId: '${user['uid']}',
                    )));
          },
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context!).colorScheme.background,
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Icon(
                Icons.person,
                size: 24,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: Text('${user['username']}'),
              subtitle: Text(
                '${user['email']}',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
