import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/di/injection_container.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/features/orders/cubit/orders_cubit.dart';
import 'package:stylish_app/features/orders/cubit/orders_state.dart';
import 'package:stylish_app/app/app_router.dart';

enum OrdersFilter { active, completed, cancelled }

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  OrdersFilter _selectedFilter = OrdersFilter.active;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>()..loadOrders(),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Orders'), centerTitle: true),
        body: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrdersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    ElevatedButton(
                      onPressed: () => context.read<OrdersCubit>().loadOrders(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: const Icon(Icons.shopping_bag, color: Colors.white, size: 50),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'You don\'t have any active orders at this time',
                        style: AppTextStyles.font14BlackRegular,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final activeOrders = state.orders.where((order) =>
              order.status.toString().contains('pending') ||
                  order.status.toString().contains('confirmed') ||
                  order.status.toString().contains('processing')
              ).toList();

              final completedOrders = state.orders.where((order) =>
                  order.status.toString().contains('delivered')
              ).toList();

              final cancelledOrders = state.orders.where((order) =>
                  order.status.toString().contains('cancelled')
              ).toList();

              List<dynamic> visibleOrders;
              String title;
              switch (_selectedFilter) {
                case OrdersFilter.active:
                  visibleOrders = activeOrders;
                  title = 'Active Orders';
                  break;
                case OrdersFilter.completed:
                  visibleOrders = completedOrders;
                  title = 'Completed Orders';
                  break;
                case OrdersFilter.cancelled:
                  visibleOrders = cancelledOrders;
                  title = 'Cancelled Orders';
                  break;
              }

              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildFilterChip('Active', OrdersFilter.active, activeOrders.isNotEmpty),
                        _buildFilterChip('Completed', OrdersFilter.completed, completedOrders.isNotEmpty),
                        _buildFilterChip('Cancelled', OrdersFilter.cancelled, cancelledOrders.isNotEmpty),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(title, style: AppTextStyles.font18BlackBold),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: visibleOrders.isEmpty
                          ? Center(
                              child: Text('No $title', style: AppTextStyles.font14GreyRegular),
                            )
                          : ListView.builder(
                              itemCount: visibleOrders.length,
                              itemBuilder: (ctx, i) => _buildOrderCard(visibleOrders[i], context),
                            ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String text, OrdersFilter filter, bool hasItems) {
    final bool selected = _selectedFilter == filter;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        label: Text(text),
        selected: selected,
        onSelected: hasItems
            ? (val) {
                if (val) setState(() => _selectedFilter = filter);
              }
            : null,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  Widget _buildOrderCard(order, BuildContext context) {
    final statusString = order.status.toString().split('.').last;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.orderDetailsRoute,
          arguments: order,
        );
      },
      child: Container(
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
                image: (order.items.isNotEmpty && (order.items.first.product.imageUrl?.isNotEmpty ?? false))
                    ? DecorationImage(
                        image: NetworkImage(order.items.first.product.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: AppColors.lightGrey,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.items.isNotEmpty ? order.items.first.product.name : 'Order #${order.orderNumber}',
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
                        order.items.isNotEmpty ? '${order.items.first.product.rating}' : '-',
                        style: AppTextStyles.font11GreyRegular,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          order.items.isNotEmpty
                              ? '${order.items.length} x \$${order.items.first.product.price.toStringAsFixed(2)}'
                              : '${order.items.length} items',
                          style: AppTextStyles.font11GreyRegular
                      ),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
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
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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