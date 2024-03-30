import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:social_app/models/user_model.dart';

import '../../../services/dio.dart';

part 'google_signin_state.dart';

class GoogleSigninCubit extends Cubit<GoogleSigninState> {
  GoogleSigninCubit() : super(GoogleSigninInitial());

  static GoogleSigninCubit get(context) => BlocProvider.of(context);

  void updateData({required String birthday, required String token}) {
    emit(GoogleSigninUpdateDataLoading());
    determinePosition().then((value) {
      DioHelper.postData(
              url: 'profile/update',
              data: {
                'birthday': birthday,
                'longitude': userLocation?.longitude,
                'latitude': userLocation?.latitude
              },
              token: token)
          .then((value) {
        UserModel res = UserModel.fromJson(value.data);
        if (res.status == true) {
          emit(GoogleSigninUpdateDataSuccess(res.user!.token!));
        } else {
          emit(GoogleSigninUpdateDataError());
        }
      }).catchError((e) {
        emit(GoogleSigninUpdateDataError());
      });
    }).catchError((e) {
      emit(GoogleSigninUpdateDataError());
    });
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
