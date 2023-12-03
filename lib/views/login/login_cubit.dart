import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../models/login_model.dart';
import '../../services/dio.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void userLogin(String email, String password){
    emit(LoginLoading());
    DioHelper.postData(url: 'login', data: {
      'email': email,
      'password': password
    }).then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      emit(LoginSuccess(loginModel!));
    }).catchError((e) {
      emit(LoginError(e.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool password = true;
  void changePasswordVisibility(){
    password = !password;
    suffix = password ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginPasswordVisibility());
  }
}
