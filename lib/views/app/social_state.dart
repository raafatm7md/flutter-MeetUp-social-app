part of 'social_cubit.dart';

@immutable
abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialGetUserLoading extends SocialState {}

class SocialGetUserSuccess extends SocialState {}

class SocialGetUserError extends SocialState {
  final String error;
  SocialGetUserError(this.error);
}

class SocialGetUserTokenError extends SocialState {}

class SocialGetAllUsersLoading extends SocialState {}

class SocialGetAllUsersSuccess extends SocialState {}

class SocialGetAllUsersError extends SocialState {
  final String error;
  SocialGetAllUsersError(this.error);
}

class SocialChangeBottomNav extends SocialState {}

class SocialNewPost extends SocialState {}

class SocialProfileImageSuccess extends SocialState {}

class SocialProfileImageError extends SocialState {}

class SocialCoverImageSuccess extends SocialState {}

class SocialCoverImageError extends SocialState {}

class SocialUploadCoverImageSuccess extends SocialState {}

class SocialUploadCoverImageError extends SocialState {}

class SocialUploadProfileImageSuccess extends SocialState {}

class SocialUploadProfileImageError extends SocialState {}

class SocialUpdateUserLoading extends SocialState {}

class SocialUpdateUserError extends SocialState {}

class SocialPostLoading extends SocialState {}

class SocialPostSuccess extends SocialState {}

class SocialPostError extends SocialState {}

class SocialPostImageSuccess extends SocialState {}

class SocialPostImageError extends SocialState {}

class SocialRemovePostImage extends SocialState {}

class SocialGetPostsLoading extends SocialState {}

class SocialGetPostsSuccess extends SocialState {}

class SocialGetPostsError extends SocialState {}

class SocialLikePostSuccess extends SocialState {}

class SocialLikePostError extends SocialState {}

class SocialSendMessageSuccess extends SocialState {}

class SocialSendMessageError extends SocialState {}

class SocialGetMessagesSuccess extends SocialState {}

class SocialShowProfile extends SocialState {}

class SocialEditingProfile extends SocialState {}

class SocialDeleteAccountLoading extends SocialState {}

class SocialDeleteAccountSuccess extends SocialState {}

class SocialDeleteAccountError extends SocialState {}
