import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stylish_app/features/auth/data/repos/auth_repo.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepo authRepo;

  SignupCubit(this.authRepo) : super(SignupInitial());

  static SignupCubit get(BuildContext context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  XFile? pickedImage;

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;

    emit(SignupLoading());

    final result = await authRepo.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text.trim(),
      image: pickedImage,
    );

    result.fold(
          (error) {
        print("❌ Signup Error: $error");
        emit(SignupError(error));
      },
          (_) {
        print("✅ Signup Success");
        emit(SignupSuccess());
      },
    );
  }

  void pickImage(XFile image) {
    pickedImage = image;
    emit(SignupInitial()); // مجرد تحديث
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
