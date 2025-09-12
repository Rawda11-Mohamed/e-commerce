import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/features/orders/cubit/orders_cubit.dart';
import 'package:stylish_app/features/orders/cubit/orders_state.dart';
import 'package:stylish_app/features/orders/data/models/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int? orderId;
  final OrderModel? order;

  const OrderDetailsScreen({super.key, this.orderId, this.order});

  @override
  Widget build(BuildContext context) {
    if (order != null) {
      return BlocProvider(
        create: (context) => getIt<OrdersCubit>(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Order Details')),
          body: _OrderDetailsBody(order: order!),
          bottomNavigationBar: _OrderActionsBar(order: order!),
        ),
      );
    }

    final orderId = this.orderId ?? (ModalRoute.of(context)?.settings.arguments as int?);
    if (orderId == null || orderId == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Invalid order ID')),
      );
    }

    return BlocProvider(
      create: (context) => getIt<OrdersCubit>()..loadOrderDetails(orderId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrderDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is OrderCancelled) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order cancelled successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    ElevatedButton(
                      onPressed: () => context.read<OrdersCubit>().loadOrderDetails(orderId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is OrderDetailsLoaded) {
              return Column(
                children: [
                  Expanded(child: _OrderDetailsBody(order: state.order)),
                  _OrderActionsBar(order: state.order),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _OrderDetailsBody extends StatelessWidget {
  final OrderModel order;
  const _OrderDetailsBody({required this.order});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: _getStatusColor(order.status.name).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: _getStatusColor(order.status.name),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Order Status',
                  style: AppTextStyles.font14GreyRegular,
                ),
                SizedBox(height: 4.h),
                Text(
                  order.statusDisplayName,
                  style: AppTextStyles.font18BlackBold.copyWith(
                    color: _getStatusColor(order.status.name),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          Text('Order Information', style: AppTextStyles.font18BlackBold),
          SizedBox(height: 16.h),
          _buildInfoRow('Order Number', order.orderNumber),
          _buildInfoRow('Order Date', _formatDate(order.createdAt)),
          if (order.trackingNumber != null)
            _buildInfoRow('Tracking Number', order.trackingNumber!),
          SizedBox(height: 24.h),

          Text('Order Items', style: AppTextStyles.font18BlackBold),
          SizedBox(height: 16.h),
          if (order.items.isEmpty)
            Text('No items found for this order.', style: AppTextStyles.font14GreyRegular)
          else
            ...order.items.map((item) => Container(
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
                      color: AppColors.lightGrey,
                      image: (item.product.imageUrl.isNotEmpty)
                          ? DecorationImage(
                        image: NetworkImage(item.product.imageUrl),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: AppTextStyles.font14BlackRegular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Qty: ${item.quantity}',
                          style: AppTextStyles.font11GreyRegular,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.font14BlackRegular,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),

          SizedBox(height: 24.h),
          Text('Order Summary', style: AppTextStyles.font18BlackBold),
          SizedBox(height: 16.h),
          _buildSummaryRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
          _buildSummaryRow('Delivery Fee', '\$${order.deliveryFee.toStringAsFixed(2)}'),
          const Divider(),
          _buildSummaryRow('Total', '\$${order.total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.font14GreyRegular),
          Text(value, style: AppTextStyles.font14BlackRegular),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.font16BlackSemiBold
                : AppTextStyles.font14GreyRegular,
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyles.font16BlackSemiBold.copyWith(color: AppColors.primary)
                : AppTextStyles.font14BlackRegular,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _OrderActionsBar extends StatelessWidget {
  final OrderModel order;
  const _OrderActionsBar({required this.order});

  bool get _canCancel {
    return order.status == OrderStatus.pending ||
        order.status == OrderStatus.confirmed ||
        order.status == OrderStatus.processing;
  }

  bool get _canTrack {
    return (order.status == OrderStatus.processing ||
        order.status == OrderStatus.shipped ||
        order.status == OrderStatus.delivered) &&
        (order.trackingNumber != null && order.trackingNumber!.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _canCancel
                  ? () {
                _showCancelDialog(context);
              }
                  : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order cannot be cancelled at this status.')),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: BorderSide(color: _canCancel ? AppColors.primary : Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('Cancel Order', style: TextStyle(color: _canCancel ? AppColors.primary : Colors.grey)),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _canTrack
                  ? () {
                _trackDriver(context);
              }
                  : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tracking is not available for this order status or tracking number is missing.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: const Text('Track Driver'),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) async {
    if (order.id == null || order.id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid order ID.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes, cancel')),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<OrdersCubit>().cancelOrder(order.id!);
    }
  }

  void _trackDriver(BuildContext context) {
    final tn = order.trackingNumber ?? 'Not available';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Track Driver'),
        content: Text('Tracking Number: $tn'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}