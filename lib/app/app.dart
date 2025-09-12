import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/app/app_router.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/features/settings/cubit/language_cubit.dart';
import 'package:stylish_app/features/profile/presentation/screens/settings_screen.dart';


class StylishApp extends StatelessWidget {
  const StylishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LanguageCubit>()..loadLanguage(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<LanguageCubit, AppLanguage>(
            builder: (context, languageState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Stylish',
                theme: ThemeData(
                  scaffoldBackgroundColor: AppColors.white,
                  primaryColor: AppColors.primary,
                  appBarTheme: AppBarTheme(
                    backgroundColor: AppColors.white,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    iconTheme: const IconThemeData(color: AppColors.black),
                    titleTextStyle: TextStyle(
                        color: AppColors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                  useMaterial3: true,
                ),
                onGenerateRoute: AppRouter.generateRoute,
                initialRoute: AppRouter.splashRoute,
              );
            },
          );
        },
      ),
    );
  }
}
