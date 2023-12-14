import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../models/user_model.dart';
import '../../services/dio.dart';
import '../../services/shared.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin(String email, String password) {
    emit(LoginLoading());
    DioHelper.postData(
        url: 'login',
        data: {'email': email, 'password': password}).then((value) {
      UserModel loginRes = UserModel.fromJson(value.data);
      if (loginRes.status == true) {
        CacheHelper.saveData('cachedEmail', email);
        CacheHelper.saveData('cachedPassword', password);
        emit(LoginSuccess(loginRes.user!.token!));
      } else
        emit(LoginError(loginRes.message!));
    }).catchError((e) {
      emit(LoginError(e.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool password = true;
  void changePasswordVisibility() {
    password = !password;
    suffix =
        password ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginPasswordVisibility());
  }
}
