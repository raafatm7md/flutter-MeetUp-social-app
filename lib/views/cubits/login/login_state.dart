part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  LoginSuccess(this.token);
}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}

class LoginPasswordVisibility extends LoginState {}
