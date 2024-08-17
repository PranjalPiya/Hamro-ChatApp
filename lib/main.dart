import 'package:chatapp/auth/auth_check.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/auth/bloc/auth_bloc.dart';
import 'package:chatapp/auth/login_or_register.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/presentation/chats/bloc/chat_bloc.dart';
import 'package:chatapp/presentation/chats/chat_services.dart';
import 'package:chatapp/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(AuthServices()),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(ChatServices()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: lightMode,
        home: const AuthCheck(),
      ),
    );
  }
}
