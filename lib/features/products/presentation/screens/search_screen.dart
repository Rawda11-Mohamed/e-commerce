import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/core/widgets/product_grid_item.dart';
import 'package:stylish_app/features/home/cubit/home_cubit.dart';
import 'package:stylish_app/features/home/cubit/home_state.dart';
import 'package:stylish_app/app/app_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = getIt<HomeCubit>();
    _searchController.addListener(() {
      setState(() {}); // Rebuild to show/hide clear button
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: AppTextStyles.font14BlackRegular,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: AppTextStyles.font14GreyRegular,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.mediumGrey,
                  size: 20.sp,
                ),
              ),
              onChanged: (value) {
                _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                  // If empty, show nothing and avoid flicker by emitting an empty view
                  if (value.trim().isEmpty) {
                    _homeCubit.searchProducts('');
                    return;
                  }
                  _homeCubit.searchProducts(value.trim());
                });
              },
            ),
          ),
          actions: [
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: AppColors.black,
                ),
                onPressed: () {
                  _searchController.clear();
                  _homeCubit.searchProducts('');
                },
              ),
          ],
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            // Handle any state changes if needed
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    ElevatedButton(
                      onPressed: () => context.read<HomeCubit>().searchProducts(_searchController.text),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is HomeLoaded) {
              if (state.products.isEmpty && _searchController.text.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 100.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No products found',
                        style: AppTextStyles.font18BlackBold,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Try searching with different keywords',
                        style: AppTextStyles.font14GreyRegular,
                      ),
                    ],
                  ),
                );
              }
              
              return GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.65,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouter.productDetailsRoute,
                      arguments: product.id,
                    ),
                    child: ProductGridItem(
                      product: product,
                      onFavoriteTap: () => context.read<HomeCubit>().toggleFavorite(product.id),
                    ),
                  );
                },
              );
            }
            
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}