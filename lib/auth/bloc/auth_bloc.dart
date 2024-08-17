import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authServices) : super(AuthBlocInitial()) {
    on<SignInButtonPressed>(signInWithFirebase);
    on<SignUpButtonPressed>(signUpWithFirebase);
  }

  Future<void> signUpWithFirebase(
      SignUpButtonPressed event, Emitter<AuthState> emitter) async {
    try {
      emitter.call(SignUpLoadingState());
      final auth = await authServices.signUpWithEmailPassword(
          event.email, event.password);
      if (event.password != event.confirmPassword) {
        emitter.call(
            const SignUpFailedState(errorMsg: 'Password does not match!'));
      }

      if (auth.user!.uid.isNotEmpty) {
        emitter.call(const SignUpSuccessState(
          successMsg: 'User Registered Successfully',
        ));
      }
    } catch (e) {
      emitter.call(
          const SignUpFailedState(errorMsg: 'Error while creating new user'));
    }
  }

  Future<void> signInWithFirebase(
      SignInButtonPressed event, Emitter<AuthState> emitter) async {
    try {
      emitter.call(SignInLoadingState());
      final auth = await authServices.signInWithEmailAndPassword(
          event.email!, event.password!);
      if (auth.user!.email!.isNotEmpty) {
        emitter.call(SignInSuccessState(
            successMsg: 'Login Successfully', userCredential: auth.user!));
      } else {
        emitter.call(const SignInFailedState(errorMsg: 'Error while logging!'));
      }
    } catch (e) {
      emitter.call(SignInFailedState(errorMsg: '$e'));
    }
  }

  final AuthServices authServices;
}
