import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/features/cart/data/models/cart_item_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;
  
  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12.r),
              image: cartItem.product.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(cartItem.product.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: cartItem.product.imageUrl.isEmpty
                ? const Center(child: Text("Img"))
                : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: AppTextStyles.font16BlackSemiBold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4.w),
                  Text(
                    cartItem.product.rating.toString(),
                    style: AppTextStyles.font11GreyRegular,
                  ),
                ]),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${cartItem.totalPrice.toStringAsFixed(2)}",
                      style: AppTextStyles.font14BlackRegular.copyWith(fontWeight: FontWeight.bold),
                    ),
                    _buildQuantitySelector(),
                  ],
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onRemove,
                    child: Text(
                      'Remove',
                      style: AppTextStyles.font11GreyRegular.copyWith(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30.w,
            height: 30.w,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: cartItem.quantity > 1 
                  ? () => onQuantityChanged(cartItem.quantity - 1)
                  : null,
              icon: const Icon(Icons.remove, color: AppColors.mediumGrey, size: 18),
            ),
          ),
          Text(
            cartItem.quantity.toString(),
            style: AppTextStyles.font14BlackRegular,
          ),
          SizedBox(
            width: 30.w,
            height: 30.w,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => onQuantityChanged(cartItem.quantity + 1),
              icon: const Icon(Icons.add, color: AppColors.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}