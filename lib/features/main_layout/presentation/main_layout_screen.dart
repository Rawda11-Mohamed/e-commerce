import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylish_app/app/app_router.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/features/home/cubit/home_cubit.dart';
import 'package:stylish_app/features/home/presentation/screens/home_screen.dart';
import 'package:stylish_app/features/products/presentation/screens/trending_products_screen.dart';
import 'package:stylish_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:stylish_app/core/theme/app_assets.dart';


class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const BestSellerProductsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..loadHomeData(),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            _buildNavItem(AppAssets.home, 'Home', 0),
            _buildNavItem(AppAssets.items, 'Items', 1),
            _buildNavItem(AppAssets.profile, 'Profile', 2),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.mediumGrey,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          elevation: 10,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRouter.cartRoute),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.shopping_cart, color: Colors.white),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(
            _selectedIndex == index ? AppColors.primary : AppColors.mediumGrey,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }
}