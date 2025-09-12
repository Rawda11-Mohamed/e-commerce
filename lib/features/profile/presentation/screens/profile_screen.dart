import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/app/app_router.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/features/profile/cubit/profile_cubit.dart';
import 'package:stylish_app/features/profile/cubit/profile_state.dart';
import 'package:stylish_app/features/profile/data/models/profile_model.dart';
import 'package:stylish_app/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..loadProfile(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile'), centerTitle: true),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileCubit>().loadProfile();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Use actual profile data from state
            ProfileModel profile;
            if (state is ProfileLoaded) {
              profile = state.profile;
            } else {
              // Fallback profile data
              profile = ProfileModel(
                name: "John Doe",
                phone: null,
              );

            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: null,
                        backgroundColor: null,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      profile.name,
                      style: AppTextStyles.font18BlackBold,
                    ),
                    Text(
                      profile.phone ?? 'No phone number',
                      style: AppTextStyles.font14GreyRegular,
                    ),
                    SizedBox(height: 40.h),
                    ProfileMenuItem(
                      icon: Icons.person_outline,
                      text: "My Profile",
                      onTap: () => Navigator.pushNamed(context, AppRouter.editProfileRoute),
                    ),
                    ProfileMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      text: "My Orders",
                      onTap: () => Navigator.pushNamed(context, AppRouter.myOrdersRoute),
                    ),
                    ProfileMenuItem(
                      icon: Icons.favorite_border,
                      text: "My Favorites",
                      onTap: () => Navigator.pushNamed(context, AppRouter.myFavoritesRoute),
                    ),
                    ProfileMenuItem(
                      icon: Icons.settings_outlined,
                      text: "Settings",
                      onTap: () => Navigator.pushNamed(context, AppRouter.settingsRoute),
                    ),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      text: "Log Out",
                      onTap: () {
                        // TODO: Implement logout logic
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.loginRoute,
                              (route) => false,
                        );
                      },
                      hasArrow: false,
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}