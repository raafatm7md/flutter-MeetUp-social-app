import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:social_app/models/post_model.dart';
import 'package:social_app/views/social_screens/chat_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/services/dio.dart';
import 'package:social_app/services/google_sign_in.dart';
import 'package:social_app/services/shared.dart';
import 'package:social_app/views/bottom_nav_bar_screens/ai_chat.dart';
import 'package:social_app/views/bottom_nav_bar_screens/chat.dart';
import 'package:social_app/views/bottom_nav_bar_screens/feed.dart';
import 'package:social_app/views/bottom_nav_bar_screens/profile.dart';
import 'package:social_app/views/bottom_nav_bar_screens/map.dart';
import '../../../models/all_users_model.dart';
import '../../../models/user_model.dart';
part 'social_state.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitial());

  static SocialCubit get(context) => BlocProvider.of(context);

  User? user;
  List<Posts>? userPosts = [];
  void getUserData() {
    emit(SocialGetUserLoading());
    DioHelper.getData(url: 'profile/show', token: CacheHelper.getData('token'))
        .then((value) {
      UserModel res = UserModel.fromJson(value.data);
      if (res.status == true) {
        user = res.user;
        DioHelper.getData(
                url: 'user/${user?.id}/posts',
                token: CacheHelper.getData('token'))
            .then((value) {
          PostsModel postsResponse = PostsModel.fromJson(value.data);
          if (postsResponse.status == true) {
            userPosts = postsResponse.data?.posts?.reversed.toList();
          }
        });
        emit(SocialGetUserSuccess());
      } else {
        emit(SocialGetUserTokenError());
      }
    }).catchError((e) {
      emit(SocialGetUserError('Check your internet connection'));
    });
  }

  List<Posts>? allPosts = [];
  void getAllPosts() {
    emit(GetAllPostsLoading());
    DioHelper.getData(url: 'posts', token: CacheHelper.getData('token'))
        .then((value) {
      PostsModel allPostsResponse = PostsModel.fromJson(value.data);
      if (allPostsResponse.status == true) {
        allPosts = allPostsResponse.data?.posts;
        emit(GetAllPostsSuccess());
      } else {
        emit(GetAllPostsError());
      }
    }).catchError((e) {
      emit(GetAllPostsError());
    });
  }

  List<Data>? allUsers;
  void getAllUserData() {
    emit(SocialGetAllUsersLoading());
    DioHelper.getData(url: 'users/all', token: CacheHelper.getData('token'))
        .then((value) {
      AllUsers res = AllUsers.fromJson(value.data);
      if (res.status == true) {
        allUsers = res.data;
        emit(SocialGetAllUsersSuccess());
      } else {
        emit(SocialGetUserTokenError());
      }
    }).catchError((e) {
      print(e.toString());
      emit(SocialGetAllUsersError('Check your internet connection'));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedScreen(),
    const ChatScreen(),
    const AIChatScreen(),
    const MapScreen(),
    ProfileScreen(),
  ];
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(SocialChangeBottomNav());
  }

  List<String> titles = ['Home', 'Chat', 'AI', 'Map', 'Profile'];

  void updateData({
    String? newName,
    double? longitude,
    double? latitude,
  }) {
    DioHelper.postData(
            url: 'profile/update',
            data: {
              'name': newName,
              'longitude': longitude,
              'latitude': latitude
            },
            token: CacheHelper.getData('token'))
        .then((value) {
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
    await Geolocator.getCurrentPosition().then((value) {
      Position userLocation = value;
      updateData(
          latitude: userLocation.latitude, longitude: userLocation.longitude);
    }).catchError((e) {});
  }

  Future<void> updateProfileImage() async {
    var picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Dio dio = Dio();
      String imagePath = pickedFile.path;
      String fileName = imagePath.split('/').last;

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath, filename: fileName),
      });

      dio
          .post(
        'http://13.36.37.63/api/profile/update',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Authorization': CacheHelper.getData('token'),
          },
        ),
      )
          .then((value) {
        UserModel res = UserModel.fromJson(value.data);
        if (res.status == true) {
          user = res.user;
          emit(SocialProfileImageSuccess());
        } else {
          emit(SocialProfileImageError());
        }
      }).catchError((e) {
        emit(SocialProfileImageError());
      });
    } else {
      print('No image selected');
      emit(SocialNoImageSelected());
    }
  }

  Future<void> updateProfileCover() async {
    var picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Dio dio = Dio();
      String imagePath = pickedFile.path;
      String fileName = imagePath.split('/').last;

      FormData formData = FormData.fromMap({
        'cover': await MultipartFile.fromFile(imagePath, filename: fileName),
      });

      dio
          .post(
        'http://13.36.37.63/api/profile/update',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Authorization': CacheHelper.getData('token'),
          },
        ),
      )
          .then((value) {
        UserModel res = UserModel.fromJson(value.data);
        if (res.status == true) {
          user = res.user;
          emit(SocialCoverImageSuccess());
        } else {
          emit(SocialCoverImageError());
        }
      }).catchError((e) {
        emit(SocialCoverImageError());
      });
    } else {
      print('No image selected');
      emit(SocialNoImageSelected());
    }
  }

  Set<Marker> mapMarkers = {};
  List<dynamic> mapUsers = [];
  createMarkers(BuildContext context) {
    DioHelper.getData(url: 'profile/show', token: CacheHelper.getData('token'))
        .then((value) {
      mapUsers.clear();
      UserModel userRes = UserModel.fromJson(value.data);
      mapUsers.add({
        'id': userRes.user!.id,
        'name': 'Me',
        'position': LatLng(userRes.user!.latitude!.toDouble(),
            userRes.user!.longitude!.toDouble()),
        'image': userRes.user!.image != null
            ? '${userRes.user!.image}'
            : 'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg',
      });

      DioHelper.getData(url: 'users/all', token: CacheHelper.getData('token'))
          .then((value) {
        AllUsers allRes = AllUsers.fromJson(value.data);
        allRes.data?.forEach((element) {
          mapUsers.add({
            'id': element.id,
            'name': '${element.name}',
            'position': LatLng(
                element.latitude!.toDouble(), element.longitude!.toDouble()),
            'image': element.image != null
                ? '${element.image}'
                : 'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg',
          });
        });
        mapMarkers.clear();
        Marker marker;

        mapUsers.forEach((user) async {
          marker = Marker(
            markerId: MarkerId(user['name']),
            position: user['position'],
            icon: await _getImageIcon(user['image']).then((value) => value),
            infoWindow: InfoWindow(
              title: user['name'],
              snippet:
                  user['id'] != userRes.user!.id ? 'Tap for chat' : 'It\'s me!',
              onTap: () {
                if (user['id'] != mapUsers[0]['id']) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailsScreen(
                            myId: mapUsers[0]['id'],
                            user: allRes.data!.singleWhere(
                                (element) => element.id == user['id'])),
                      ));
                }
              },
            ),
          );
          mapMarkers.add(marker);
          emit(MapMarkerCreated());
        });
      });
    });
  }

  Future<BitmapDescriptor> _getImageIcon(String image) async {
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(image);
    return convertImageFileToBitmapDescriptor(markerImageFile, size: 200);
  }

  static Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(
    File imageFile, {
    int size = 100,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        Radius.circular(100)));
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size / 2.toDouble(), size + 20.toDouble(), 10, 10),
        Radius.circular(100)));
    canvas.clipPath(clipPath);

    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    final _image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  List<Map<String, dynamic>> chatBotHistory = [];
}
