import 'package:dartz/dartz.dart';
import 'package:stylish_app/core/api/api_helper.dart';
import 'package:stylish_app/core/api/api_response.dart';
import 'package:stylish_app/core/api/end_points.dart';
import 'package:stylish_app/features/profile/data/models/profile_model.dart';
import 'dart:io';

class ProfileRepo {
  final ApiHelper apiHelper;

  ProfileRepo({required this.apiHelper});

  Future<Either<String, ProfileModel>> getProfile() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.getUserData,
        isProtected: true,
      );

      if (response.status) {
        try {
          ProfileModel profile = ProfileModel.fromJson(response.data);
          return Right(profile);
        } catch (e) {
          print('Error parsing profile response: $e');
          return Left('Failed to parse profile data: $e');
        }
      } else {
        return Left(response.message ?? 'Failed to load profile');
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, ProfileModel>> updateProfile(
      ProfileModel profile, {
        File? image,
      }) async {
    try {
      // Send only text data as Map
      Map<String, dynamic> data = {
        'name': profile.name,
        if (profile.phone != null && profile.phone!.isNotEmpty) 'phone': profile.phone,
      };

      print('Sending profile update data: $data');

      var response = await apiHelper.putRequest(
        endPoint: EndPoints.updateProfile,
        data: data,
        isProtected: true,
      );

      if (response.status) {
        try {
          ProfileModel updatedProfile = ProfileModel.fromJson(response.data);
          return Right(updatedProfile);
        } catch (e) {
          print('Error parsing profile update response: $e');
          return Left('Failed to parse profile data: $e');
        }
      } else {
        return Left(response.message ?? 'Failed to update profile');
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}