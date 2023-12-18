import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_app/services/dio.dart';
import 'package:social_app/services/google_sign_in.dart';
import 'package:social_app/services/shared.dart';
import 'package:social_app/views/social_screens/ai_chat.dart';
import 'package:social_app/views/social_screens/chat.dart';
import 'package:social_app/views/social_screens/feed.dart';
import 'package:social_app/views/social_screens/settings.dart';
import 'package:social_app/views/social_screens/users.dart';
import '../../models/user_model.dart';
part 'social_state.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitial());

  static SocialCubit get(context) => BlocProvider.of(context);

  User? user;
  void getUserData() {
    emit(SocialGetUserLoading());
    DioHelper.getData(url: 'profile/show', token: CacheHelper.getData('token'))
        .then((value) {
      UserModel res = UserModel.fromJson(value.data);
      if (res.status == true) {
        user = res.user;
        emit(SocialGetUserSuccess());
      } else {
        emit(SocialGetUserTokenError());
      }
    }).catchError((e) {
      emit(SocialGetUserError('Check your internet connection'));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedScreen(),
    const ChatScreen(),
    const UsersScreen(),
    const AIChatScreen(),
    SettingsScreen(),
  ];
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(SocialChangeBottomNav());
  }

  List<String> titles = ['Home', 'Chat', 'Users Map', 'AI', 'Profile'];

  void updateData({
    String? newName,
    double? longitude,
    double? latitude,
  }) {
    DioHelper.postData(
            url: 'profile/update',
            data: {
              'name': newName,
              'image': null,
              'cover': null,
              'longitude': longitude,
              'latitude': latitude
            },
            token: CacheHelper.getData('token'))
        .then((value) {
          print(value.data);
      UserModel res = UserModel.fromJson(value.data);
      if (res.status == true) {
        user = res.user;
        emit(SocialShowProfile());
      } else {
        emit(SocialUpdateUserError());
      }
    }).catchError((e) {
      emit(SocialUpdateUserError());
    });
  }

  void editProfile() {
    emit(SocialEditingProfile());
  }

  void logout() {
    GoogleSignInService.logout();
    DioHelper.postData(
        url: 'logout', data: {}, token: CacheHelper.getData('token'));
    CacheHelper.removeData('token');
  }


  Future<void> updateLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    await Geolocator.getCurrentPosition()
        .then((value) {
      Position userLocation = value;
      updateData(latitude: userLocation.latitude, longitude: userLocation.longitude);
    })
        .catchError((e) {});
  }
}
