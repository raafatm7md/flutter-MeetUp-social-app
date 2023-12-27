part of 'google_signin_cubit.dart';

@immutable
abstract class GoogleSigninState {}

class GoogleSigninInitial extends GoogleSigninState {}

class GoogleSigninUpdateDataLoading extends GoogleSigninState {}

class GoogleSigninUpdateDataSuccess extends GoogleSigninState {
  final String token;
  GoogleSigninUpdateDataSuccess(this.token);
}

class GoogleSigninUpdateDataError extends GoogleSigninState {}

