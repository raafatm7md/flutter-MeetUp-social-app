import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:social_app/models/reset_password_model.dart';
import 'package:social_app/services/dio.dart';

import '../../../services/shared.dart';

part 'new_post_state.dart';

class NewPostCubit extends Cubit<NewPostState> {
  NewPostCubit() : super(NewPostInitial());

  static NewPostCubit get(context) => BlocProvider.of(context);

  File? postImage;
  String? imgPath;
  Future<void> getPostImage() async {
    var picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imgPath = pickedFile.path;
      postImage = File(pickedFile.path);
      emit(NewPostImageSuccess());
    } else {
      print('No image selected');
      emit(NewPostImageError());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImage());
  }

  Future<void> createPost({String? text}) async {
    emit(UploadPostLoading());
    if (postImage != null) {
      Dio dio = Dio();
      String? imagePath = imgPath;
      String? fileName = imagePath?.split('/').last;

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath!, filename: fileName),
        'content': text
      });
      dio
          .post(
        '${baseUrl}user/posts/create',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Authorization': CacheHelper.getData('token'),
          },
        ),
      )
          .then((value) {
        ResetPassModel response = ResetPassModel.fromJson(value.data);
        if (response.status == true) {
          emit(UploadPostSuccess());
        }
      });
    } else if (text!.isNotEmpty) {
      DioHelper.postData(
              url: 'user/posts/create',
              data: {'content': text},
              token: CacheHelper.getData('token'))
          .then((value) {
        ResetPassModel response = ResetPassModel.fromJson(value.data);
        if (response.status == true) {
          emit(UploadPostSuccess());
        }
      });
    } else {
      emit(UploadPostError('Can\'t create empty post'));
    }
  }
}
