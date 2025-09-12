import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/features/products/data/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel? product;
  final VoidCallback? onFavoriteTap;

  const ProductGridItem({
    super.key,
    this.product,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return _buildPlaceholder();
    }

    return Container(
      height: 335.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: product!.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: product!.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180.h,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300]!,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300]!,
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      ),
                    )
                        : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Text("No Image"),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        product!.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: product!.isFavorite ? AppColors.primary : Colors.grey,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Flexible(
            child: Text(
              product!.name,
              style: AppTextStyles.font16BlackSemiBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              product!.description,
              style: AppTextStyles.font11GreyRegular,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 14.sp),
              SizedBox(width: 4.w),
              Text(
                product!.rating.toString(),
                style: AppTextStyles.font11GreyRegular,
              ),
              const Spacer(),
              Text(
                '\$${product!.price.toStringAsFixed(2)}',
                style: AppTextStyles.font14BlackRegular.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 180.h,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: const Center(child: Text("Loading...")),
        ),
        SizedBox(height: 8.h),
        Text('Loading...', style: AppTextStyles.font16BlackSemiBold),
        Text('Please wait...', style: AppTextStyles.font11GreyRegular, maxLines: 2, overflow: TextOverflow.ellipsis),
        SizedBox(height: 4.h),
        Text('\$0.00', style: AppTextStyles.font14BlackRegular.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}