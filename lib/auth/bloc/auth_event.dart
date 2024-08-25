part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckEvent extends AuthEvent {}

class SignInButtonPressed extends AuthEvent {
  final String? email;
  final String? password;

  const SignInButtonPressed({required this.email, required this.password});
  @override
  List<Object> get props => [email!, password!];
}

class SignUpButtonPressed extends AuthEvent {
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? userName;

  const SignUpButtonPressed(
      {required this.email,
      required this.userName,
      required this.password,
      required this.confirmPassword});
  @override
  List<Object> get props => [email!, password!, confirmPassword!, userName!];
}
