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
import 'package:stylish_app/features/orders/cubit/orders_cubit.dart';
import 'package:stylish_app/features/orders/cubit/orders_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedPaymentMethod = 'Cash on Delivery';

  @override
  void initState() {
    super.initState();
    _addressController.text = "123 Main Street, City, Country";
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          centerTitle: true,
        ),
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
          builder: (context, cartState) {
            if (cartState is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (cartState is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${cartState.error}'),
                    ElevatedButton(
                      onPressed: () => context.read<CartCubit>().loadCart(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (cartState is CartLoaded) {
              if (cartState.cartItems.isEmpty) {
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
                    ],
                  ),
                );
              }

              return _buildCheckoutContent(context, cartState);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildCheckoutContent(BuildContext context, CartLoaded state) {
    final cartCubit = context.read<CartCubit>();

    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, orderState) {
        if (orderState is OrderCreated) {
          // Clear cart after successful order
          cartCubit.clearCart();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Order placed successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to order confirmation
          Navigator.pushNamed(
            context,
            AppRouter.orderDetailsRoute,
            arguments: orderState.order,
          );

        } else if (orderState is OrdersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${orderState.error}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section
            _buildDeliveryAddressSection(),

            SizedBox(height: 24.h),

            // Shopping List
            Text("Shopping List", style: AppTextStyles.font18BlackBold),
            SizedBox(height: 16.h),

            // Cart Items
            ...state.cartItems.map((cartItem) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                        image: NetworkImage(cartItem.product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.product.name,
                          style: AppTextStyles.font14BlackRegular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 14),
                            SizedBox(width: 4.w),
                            Text(
                              '${cartItem.product.rating}',
                              style: AppTextStyles.font11GreyRegular,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${cartItem.quantity} x \$${cartItem.product.price.toStringAsFixed(2)}',
                              style: AppTextStyles.font11GreyRegular
                            ),
                            Text(
                              '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                              style: AppTextStyles.font14BlackRegular.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),

            SizedBox(height: 24.h),
            // Place Order Button
            BlocConsumer<OrdersCubit, OrdersState>(
              listener: (context, state) {
                if (state is OrdersLoading) {
                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is OrderCreated || state is OrdersError) {
                  // Close loading dialog
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
              builder: (context, state) {
                return PrimaryButton(
                  onPressed: state is OrdersLoading
                      ? null
                      : () => _placeOrder(context, state, cartCubit),
                  text: 'Place Order',

                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Address',
          style: AppTextStyles.font16BlackSemiBold,
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(12.w),
          child: TextField(
            controller: _addressController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter your delivery address',
              border: InputBorder.none,
              hintStyle: TextStyle(color: AppColors.mediumGrey),
            ),
            style: AppTextStyles.font14BlackRegular,
          ),
        ),
      ],
    );
  }


  void _placeOrder(BuildContext context, OrdersState state, CartCubit cartCubit) {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a delivery address"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final cartState = cartCubit.state;
    if (cartState is CartLoaded) {
      // Prepare items for order
      final items = cartState.cartItems
          .map((item) => {
        'product_id': item.product.id,
        'quantity': item.quantity,
        'price': item.product.price,
        'total_price': item.totalPrice,
      })
          .toList();

      context.read<OrdersCubit>().createOrder(
        items: items,
        shippingAddress: _addressController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );
    }
  }
}