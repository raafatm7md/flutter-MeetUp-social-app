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

class SocialProfileImageSuccess extends SocialState {}

class SocialProfileImageError extends SocialState {}

class SocialCoverImageSuccess extends SocialState {}

class SocialCoverImageError extends SocialState {}

class SocialUpdateUserError extends SocialState {}

class SocialShowProfile extends SocialState {}

class SocialEditingProfile extends SocialState {}

class SocialNoImageSelected extends SocialState {}

class MapMarkerCreated extends SocialState {}

class GetAllPostsLoading extends SocialState {}

class GetAllPostsSuccess extends SocialState {}

class GetAllPostsError extends SocialState {}
