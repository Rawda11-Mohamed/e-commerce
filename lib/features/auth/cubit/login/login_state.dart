
import 'package:stylish_app/features/auth/data/models/user_model.dart';
abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final UserModel user;
  LoginSuccess(this.user);
}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}

