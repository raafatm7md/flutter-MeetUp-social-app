import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/services/shared.dart';
import 'package:social_app/views/social_screens/ai_chat.dart';
import 'package:social_app/views/social_screens/chat.dart';
import 'package:social_app/views/social_screens/feed.dart';
import 'package:social_app/views/social_screens/new_post.dart';
import 'package:social_app/views/social_screens/settings.dart';
import 'package:social_app/views/social_screens/users.dart';
import '../../models/login_model.dart';
part 'social_state.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitial());

  static SocialCubit get(context) => BlocProvider.of(context);

  // User? model;
  // void getUserData() {
  //   emit(SocialGetUserLoading());
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(CacheHelper.getData('uId'))
  //       .get()
  //       .then((value) {
  //     model = UserModel.fromJson(value.data()!);
  //     emit(SocialGetUserSuccess());
  //   }).catchError((e) {
  //     emit(SocialGetUserError(e.toString()));
  //   });
  // }

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedScreen(),
    const ChatScreen(),
    const UsersScreen(),
    const AIChatScreen(),
    const SettingsScreen(),
  ];
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(SocialChangeBottomNav());
  }

  List<String> titles = ['Home', 'Chat', 'Users Map', 'AI', 'Settings'];

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImageSuccess());
    } else {
      print('No image selected');
      emit(SocialProfileImageError());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImageSuccess());
    } else {
      print('No image selected');
      emit(SocialCoverImageError());
    }
  }

  // String coverImgUrl = '';
  // void uploadCover() {
  //   firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
  //       .putFile(coverImage!)
  //       .then((value) {
  //     value.ref.getDownloadURL().then((value) {
  //       coverImgUrl = value;
  //       updateCover();
  //       emit(SocialUploadCoverImageSuccess());
  //     }).catchError((e) {
  //       emit(SocialUploadCoverImageError());
  //     });
  //   }).catchError((e) {
  //     emit(SocialUploadCoverImageError());
  //   });
  // }
  //
  // String profileImgUrl = '';
  // void uploadProfile() {
  //   firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
  //       .putFile(profileImage!)
  //       .then((value) {
  //     value.ref.getDownloadURL().then((value) {
  //       profileImgUrl = value;
  //       updateProfile();
  //       emit(SocialUploadCoverImageSuccess());
  //     }).catchError((e) {
  //       emit(SocialUploadCoverImageError());
  //     });
  //   }).catchError((e) {
  //     emit(SocialUploadCoverImageError());
  //   });
  // }
  //
  // void updateUser(
  //     {required String name, required String phone, required String bio}) {
  //   emit(SocialUpdateUserLoading());
  //
  //   if (coverImage != null) {
  //     uploadCover();
  //   }
  //   if (profileImage != null) {
  //     uploadProfile();
  //   }
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(model?.uId)
  //       .update({'name': name, 'phone': phone, 'bio': bio}).then((value) {
  //     getUserData();
  //   }).catchError((e) {
  //     emit(SocialUpdateUserError());
  //   });
  // }
  //
  // void updateCover() {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(model?.uId)
  //       .update({'cover': coverImgUrl}).then((value) {
  //     getUserData();
  //   }).catchError((e) {
  //     emit(SocialUpdateUserError());
  //   });
  // }
  //
  // void updateProfile() {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(model?.uId)
  //       .update({'image': profileImgUrl}).then((value) {
  //     getUserData();
  //   }).catchError((e) {
  //     emit(SocialUpdateUserError());
  //   });
  // }

  File? postImage;
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImageSuccess());
    } else {
      print('No image selected');
      emit(SocialPostImageError());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImage());
  }

  // void uploadPost({
  //   required String dateTime,
  //   required String text,
  // }) {
  //   emit(SocialPostLoading());
  //
  //   firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
  //       .putFile(postImage!)
  //       .then((value) {
  //     value.ref.getDownloadURL().then((value) {
  //       createPost(dateTime: dateTime, text: text, postImage: value);
  //     }).catchError((e) {
  //       emit(SocialPostError());
  //     });
  //   }).catchError((e) {
  //     emit(SocialPostError());
  //   });
  // }
  //
  // void createPost(
  //     {required String dateTime, required String text, String? postImage}) {
  //   emit(SocialPostLoading());
  //
  //   PostModel postModel = PostModel(
  //     name: model?.name,
  //     uId: model?.uId,
  //     image: model?.image,
  //     dateTime: dateTime,
  //     text: text,
  //     postImage: postImage ?? '',
  //   );
  //
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .add(postModel.toMap())
  //       .then((value) {
  //     emit(SocialPostSuccess());
  //   }).catchError((e) {
  //     emit(SocialPostError());
  //   });
  // }
  //
  // List<PostModel> posts = [];
  // List<String> postsId = [];
  // List<int> likes = [];
  // void getPosts() {
  //   emit(SocialGetPostsLoading());
  //   FirebaseFirestore.instance.collection('posts').get().then((value) {
  //     value.docs.forEach((element) {
  //       element.reference.collection('likes').get().then((value) {
  //         likes.add(value.docs.length);
  //         posts.add(PostModel.fromJson(element.data()));
  //         postsId.add(element.id);
  //       }).catchError((e) {});
  //     });
  //     emit(SocialGetPostsSuccess());
  //   }).catchError((e) {
  //     emit(SocialGetPostsError());
  //   });
  // }
  //
  // void likePost(String postID) {
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postID)
  //       .collection('likes')
  //       .doc(model?.uId)
  //       .set({'like': true}).then((value) {
  //     emit(SocialLikePostSuccess());
  //   }).catchError((e) {
  //     emit(SocialLikePostError());
  //   });
  // }
  //
  // List<UserModel> users = [];
  // void getAllUsers() {
  //   users = [];
  //   emit(SocialGetAllUsersLoading());
  //   FirebaseFirestore.instance.collection('users').get().then((value) {
  //     value.docs.forEach((element) {
  //       if (element.data()['uId'] != model?.uId)
  //         users.add(UserModel.fromJson(element.data()));
  //     });
  //     emit(SocialGetAllUsersSuccess());
  //   }).catchError((e) {
  //     emit(SocialGetAllUsersError(e.toString()));
  //   });
  // }
  //
  // void sendMessage(
  //     {required String receiverId,
  //     required String dateTime,
  //     required String text}) {
  //   MessageModel message = MessageModel(
  //       senderId: model?.uId,
  //       receiverId: receiverId,
  //       dateTime: dateTime,
  //       text: text);
  //
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(model?.uId)
  //       .collection('chats')
  //       .doc(receiverId)
  //       .collection('messages')
  //       .add(message.toMap())
  //       .then((value) {
  //     emit(SocialSendMessageSuccess());
  //   }).catchError((e) {
  //     emit(SocialSendMessageError());
  //   });
  //
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(receiverId)
  //       .collection('chats')
  //       .doc(model?.uId)
  //       .collection('messages')
  //       .add(message.toMap())
  //       .then((value) {
  //     emit(SocialSendMessageSuccess());
  //   }).catchError((e) {
  //     emit(SocialSendMessageError());
  //   });
  // }
  //
  // List<MessageModel> messages = [];
  // void getMessages({required String receiverId}) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(model?.uId)
  //       .collection('chats')
  //       .doc(receiverId)
  //       .collection('messages')
  //   .orderBy('dateTime')
  //       .snapshots()
  //       .listen((event) {
  //         messages = [];
  //         event.docs.forEach((element) {
  //           messages.add(MessageModel.fromJson(element.data()));
  //         });
  //         emit(SocialGetMessagesSuccess());
  //   });
  // }
}
