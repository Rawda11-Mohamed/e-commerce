import 'package:stylish_app/features/profile/data/models/profile_model.dart';
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  ProfileLoaded({required this.profile});
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}

class ProfileUpdated extends ProfileState {
  final ProfileModel profile;

  ProfileUpdated({required this.profile});
}