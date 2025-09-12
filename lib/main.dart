import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/di/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_app/features/cart/cubit/cart_cubit.dart';
import 'package:stylish_app/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    BlocProvider<CartCubit>(
      create: (context) => di.getIt<CartCubit>(),
      child: const StylishApp(),
    ),
  );
}