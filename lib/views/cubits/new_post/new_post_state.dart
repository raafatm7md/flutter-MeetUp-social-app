part of 'new_post_cubit.dart';

@immutable
abstract class NewPostState {}

class NewPostInitial extends NewPostState {}

class UploadPostLoading extends NewPostState {}

class UploadPostSuccess extends NewPostState {}

class UploadPostError extends NewPostState {
  final String error;
  UploadPostError(this.error);
}

class NewPostImageSuccess extends NewPostState {}

class NewPostImageError extends NewPostState {}

class RemovePostImage extends NewPostState {}