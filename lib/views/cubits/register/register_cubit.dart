import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/dio.dart';
import '../../../services/shared.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      String username, String email, String password, String birthday) {
    emit(RegisterLoading());
    determinePosition().then((value) {
      DioHelper.postData(url: 'register', data: {
        'name': username.toLowerCase(),
        'email': email,
        'password': password,
        'birthday': birthday,
        'longitude': userLocation?.longitude,
        'latitude': userLocation?.latitude
      }).then((value) {
        UserModel registerRes = UserModel.fromJson(value.data);
        if (registerRes.status == true) {
          CacheHelper.saveData('cachedPassword', password);
          CacheHelper.saveData('cachedEmail', email);
          emit(RegisterSuccess(registerRes.user!.token!));
        } else
          emit(RegisterError(registerRes.errors![0]));
      }).catchError((e) {
        emit(RegisterError(e.toString()));
      });
    }).catchError((e) {
      emit(RegisterError(e.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool password = true;
  void changePasswordVisibility() {
    password = !password;
    suffix =
        password ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterPasswordVisibility());
  }

  Position? userLocation;
  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    userLocation = await Geolocator.getCurrentPosition();
  }
}
