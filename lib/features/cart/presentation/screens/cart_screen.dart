import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/app/app_router.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/core/widgets/primary_button.dart';
import 'package:stylish_app/features/cart/cubit/cart_cubit.dart';
import 'package:stylish_app/features/cart/cubit/cart_state.dart';
import 'package:stylish_app/features/cart/presentation/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), centerTitle: true),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  ElevatedButton(
                    onPressed: () => context.read<CartCubit>().loadCart(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Your cart is empty',
                      style: AppTextStyles.font18BlackBold,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Add some products to get started',
                      style: AppTextStyles.font14GreyRegular,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: [
                      Text("Shopping List", style: AppTextStyles.font18BlackBold),
                      SizedBox(height: 16.h),
                      ...state.cartItems.map((cartItem) => CartItemWidget(
                        cartItem: cartItem,
                        onQuantityChanged: (quantity) {
                          context.read<CartCubit>().updateQuantity(
                            cartItem.id,
                            quantity,
                          );
                        },
                        onRemove: () {
                          context.read<CartCubit>().removeFromCart(cartItem.id);
                        },
                      )),
                    ],
                  ),
                ),
                _buildOrderSummary(context, state),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartLoaded state) {
    final cubit = context.read<CartCubit>();
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 10)],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          _summaryRow("Subtotal", "\$${cubit.subtotal.toStringAsFixed(2)}"),
          SizedBox(height: 8.h),
          _summaryRow("Tax and Fees", "\$${cubit.tax.toStringAsFixed(2)}"),
          SizedBox(height: 8.h),
          _summaryRow("Delivery Fee", "\$${cubit.deliveryFee.toStringAsFixed(2)}"),
          const Divider(height: 32),
          _summaryRow("Order Total", "\$${cubit.total.toStringAsFixed(2)}", isTotal: true),
          SizedBox(height: 24.h),
          PrimaryButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.checkoutRoute),
            text: 'Checkout',
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String amount, {bool isTotal = false}) {
    final style = isTotal ? AppTextStyles.font16BlackSemiBold : AppTextStyles.font14GreyRegular;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(amount, style: style.copyWith(color: AppColors.black)),
      ],
    );
  }
}