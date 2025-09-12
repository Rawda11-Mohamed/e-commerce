import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/features/settings/cubit/language_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<LanguageCubit>();
        cubit.loadLanguage();
        return cubit;
      },
      child:Scaffold(
        appBar: AppBar(title: const Text("Settings")),
        body: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              ListTile(
                title: const Text("Language"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _saveLanguage('ar'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _selectedLanguage == 'ar'
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'AR',
                          style: TextStyle(
                            color: _selectedLanguage == 'ar'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _saveLanguage('en'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _selectedLanguage == 'en'
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'EN',
                          style: TextStyle(
                            color: _selectedLanguage == 'en'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
  String _selectedLanguage = 'en';
  void _saveLanguage(String code) {
    setState(() {
      _selectedLanguage = code;
    });
  }
}
