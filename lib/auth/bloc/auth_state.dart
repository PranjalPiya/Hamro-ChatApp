part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthBlocInitial extends AuthState {}

final class AuthCheckState extends AuthState {}

final class SignInLoadingState extends AuthState {}

final class SignInSuccessState extends AuthState {
  final User userCredential;
  final String successMsg;

  const SignInSuccessState(
      {required this.successMsg, required this.userCredential});
  @override
  List<Object> get props => [userCredential, successMsg];
}

final class SignInFailedState extends AuthState {
  final String? errorMsg;

  const SignInFailedState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg!];
}

final class SignUpLoadingState extends AuthState {}

final class SignUpSuccessState extends AuthState {
  final String? successMsg;

  const SignUpSuccessState({required this.successMsg});

  @override
  List<Object> get props => [successMsg!];
}

final class SignUpFailedState extends AuthState {
  final String? errorMsg;
  const SignUpFailedState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg!];
}
