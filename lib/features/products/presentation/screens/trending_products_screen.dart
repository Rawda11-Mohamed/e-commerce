import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/core/widgets/product_grid_item.dart';
import 'package:stylish_app/features/home/cubit/home_cubit.dart';
import 'package:stylish_app/features/home/cubit/home_state.dart';
import 'package:stylish_app/app/app_router.dart';

// Renamed from TrendingProductsScreen to match the available backend endpoint.
class BestSellerProductsScreen extends StatelessWidget {
  const BestSellerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Best Seller Products', style: AppTextStyles.font18BlackBold),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
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
                      onPressed: () => context.read<HomeCubit>().loadHomeData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded) {
              final bestSellerProducts = state.trendingProducts;

              return GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.65,
                ),
                itemCount: bestSellerProducts.length,
                itemBuilder: (context, index) {
                  final product = bestSellerProducts[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouter.productDetailsRoute,
                      arguments: product.id,
                    ),
                    child: ProductGridItem(
                      product: product,
                      onFavoriteTap: () =>
                          context.read<HomeCubit>().toggleFavorite(product.id),
                    ),
                  );
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
    );
  }
}