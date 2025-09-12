import 'package:stylish_app/features/auth/data/models/user_model.dart';

class LoginResponseModel {
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;

  LoginResponseModel({this.user, this.accessToken, this.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}