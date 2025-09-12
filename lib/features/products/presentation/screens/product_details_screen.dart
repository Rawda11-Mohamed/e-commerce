import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/core/widgets/primary_button.dart';
import 'package:stylish_app/features/products/cubit/product_details_cubit.dart';
import 'package:stylish_app/features/products/cubit/product_details_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int? productId;

  const ProductDetailsScreen({super.key, this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final productId =
        widget.productId ?? (ModalRoute.of(context)?.settings.arguments as int?);

    if (productId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: const Center(child: Text('Product not found')),
      );
    }

    return BlocProvider(
      create: (context) =>
      getIt<ProductDetailsCubit>()..loadProductDetails(productId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product'),
          actions: [
            BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              builder: (context, state) {
                if (state is ProductDetailsLoaded) {
                  return IconButton(
                    onPressed: () {
                      context.read<ProductDetailsCubit>().toggleFavorite(context);
                    },
                    icon: Icon(
                      state.product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: state.product.isFavorite
                          ? AppColors.primary
                          : AppColors.black,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
        body: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
          listener: (context, state) {
            if (state is ProductDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ProductDetailsAddedToCart) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added to cart!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    ElevatedButton(
                      onPressed: () => context
                          .read<ProductDetailsCubit>()
                          .loadProductDetails(productId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductDetailsLoaded) {
              final cubit = context.read<ProductDetailsCubit>();
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 413.h,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: state.product.imageUrl.isNotEmpty
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: CachedNetworkImage(
                                imageUrl: state.product.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 413.h,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => const Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            )
                                : const Center(child: Text("No Image Available")),
                          ),
                          SizedBox(height: 20.h),
                          Text(state.product.name,
                              style: AppTextStyles.font24BlackBold),
                          SizedBox(height: 8.h),
                          Text(
                            state.product.description,
                            style: AppTextStyles.font14GreyRegular,
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber, size: 16.sp),
                              SizedBox(width: 4.w),
                              Text(
                                state.product.rating.toString(),
                                style: AppTextStyles.font14GreyRegular,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '(${state.product.reviewCount} reviews)',
                                style: AppTextStyles.font14GreyRegular,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${state.product.price.toStringAsFixed(2)}",
                                style: AppTextStyles.font18BlackBold
                                    .copyWith(color: AppColors.primary),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: cubit.decreaseQuantity,
                                      icon: const Icon(Icons.remove,
                                          color: AppColors.mediumGrey),
                                    ),
                                    Text(
                                      cubit.quantity.toString(),
                                      style: AppTextStyles.font16BlackSemiBold,
                                    ),
                                    IconButton(
                                      onPressed: cubit.increaseQuantity,
                                      icon: const Icon(Icons.add,
                                          color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Stock: ${state.product.stock} available',
                            style: AppTextStyles.font14GreyRegular,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: PrimaryButton(
                      onPressed:
                        state is ProductDetailsLoading ? null : () => cubit.addToCart(context, cubit.quantity),
                      text: 'Add To Cart',
                    ),
                  )
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
