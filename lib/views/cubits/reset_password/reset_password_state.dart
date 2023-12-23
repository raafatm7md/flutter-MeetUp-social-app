part of 'reset_password_cubit.dart';

@immutable
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class SendOTPLoading extends ResetPasswordState {}

class OTPSent extends ResetPasswordState {
  final ResetPassModel respond;
  OTPSent(this.respond);
}

class OTPError extends ResetPasswordState {
  final String error;
  OTPError(this.error);
}

class ConfirmOTPLoading extends ResetPasswordState {}

class ConfirmOTPSuccess extends ResetPasswordState {
  final ResetPassModel respond;
  ConfirmOTPSuccess(this.respond);
}

class ConfirmOTPError extends ResetPasswordState {
  final String error;
  ConfirmOTPError(this.error);
}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPassModel respond;
  ResetPasswordSuccess(this.respond);
}

class ResetPasswordError extends ResetPasswordState {
  final String error;
  ResetPasswordError(this.error);
}
