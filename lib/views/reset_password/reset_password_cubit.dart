import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../models/reset_password_model.dart';
import '../../services/dio.dart';
part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  static ResetPasswordCubit get(context) => BlocProvider.of(context);

  ResetPassModel? respond;
  void sendOTP(String email) {
    emit(SendOTPLoading());
    DioHelper.postData(url: 'forget', data: {
      'email': email,
    }).then((value) {
      respond = ResetPassModel.fromJson(value.data);
      emit(OTPSent(respond!));
    }).catchError((e) {
      emit(OTPError(e.toString()));
      print(e.toString());
    });
  }

  ResetPassModel? otpRespond;
  void confirmOTP(String otp) {
    emit(ConfirmOTPLoading());
    DioHelper.postData(url: 'otp/$otp', data: {}).then((value) {
      otpRespond = ResetPassModel.fromJson(value.data);
      emit(ConfirmOTPSuccess(respond!));
    }).catchError((e) {
      emit(ConfirmOTPError(e.toString()));
      print(e.toString());
    });
  }

  void resetPassword(
      {required String otp,
      required String password,
      required String passwordConfirmation}) {
    emit(ConfirmOTPLoading());
    DioHelper.postData(url: 'reset/$otp', data: {
      'password': password,
      'password_confirmation': passwordConfirmation
    }).then((value) {
      emit(ResetPasswordSuccess(ResetPassModel.fromJson(value.data)));
    }).catchError((e) {
      emit(ResetPasswordError(e.toString()));
      print(e.toString());
    });
  }
}
