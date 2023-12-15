import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/services/dio.dart';
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

  void sendEditedData({
    String? newName,
  }) {
    DioHelper.postData(
            url: 'profile/update',
            data: {'name': newName},
            token: CacheHelper.getData('token'))
        .then((value) {
      print(newName);
      user?.name = newName;
      emit(SocialShowProfile());
    }).catchError((e) {
      emit(SocialUpdateUserError());
    });
  }

  void editProfile() {
    emit(SocialEditingProfile());
  }

  void logout() {
    DioHelper.postData(
        url: 'logout', data: {}, token: CacheHelper.getData('token'));
    CacheHelper.removeData('token');
  }
}
