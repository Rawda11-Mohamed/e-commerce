import 'package:bloc/bloc.dart';
import 'package:stylish_app/features/profile/data/models/profile_model.dart';
import 'package:stylish_app/features/profile/data/repos/profile_repo.dart';
import 'profile_state.dart';
import 'dart:io';



class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;
  ProfileCubit(this._profileRepo) : super(ProfileInitial());

  ProfileModel? _profile;

  ProfileModel? get profile => _profile;

  void loadProfile() async {
    emit(ProfileLoading());
    final result = await _profileRepo.getProfile();
    result.fold(
          (failure) => emit(ProfileError(failure.toString())),
          (profile) {
        _profile = profile;
        emit(ProfileLoaded(profile: profile));
      },
    );
  }

  void updateProfile({
    required String name,
    required String phone,
    File? image,
  }) async {
    // Check if anything changed - normalize phone numbers for comparison
    final currentPhone = _profile?.phone ?? '';
    final newPhone = phone.trim();
    final normalizedCurrentPhone = currentPhone.isEmpty ? null : currentPhone;
    final normalizedNewPhone = newPhone.isEmpty ? null : newPhone;
    
    final hasNameChanged = name.trim() != (_profile?.name ?? '').trim();
    final hasPhoneChanged = normalizedNewPhone != normalizedCurrentPhone;
    final hasImageChanged = image != null;

    print('Profile update check:');
    print('  Current name: "${_profile?.name ?? ''}"');
    print('  New name: "$name"');
    print('  Name changed: $hasNameChanged');
    print('  Current phone: "$currentPhone"');
    print('  New phone: "$newPhone"');
    print('  Phone changed: $hasPhoneChanged');
    print('  Image changed: $hasImageChanged');

    if (!hasNameChanged && !hasPhoneChanged && !hasImageChanged) {
      emit(ProfileError('Nothing to update. Please provide a name, phone or image to update.'));
      return;
    }

    emit(ProfileLoading());

    final updatedProfile = ProfileModel(
      name: name.trim(),
      phone: newPhone.isEmpty ? null : newPhone,
    );

    try {
      final result = await _profileRepo.updateProfile(updatedProfile, image: image);
      result.fold(
            (error) => emit(ProfileError(error)),
            (profile) {
          _profile = profile;
          emit(ProfileUpdated(profile: profile));
        },
      );
    } catch (e) {
      emit(ProfileError('Network error: $e'));
    }
  }
}