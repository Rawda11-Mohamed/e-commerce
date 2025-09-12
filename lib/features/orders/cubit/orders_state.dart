import 'package:stylish_app/features/orders/data/models/order_model.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  OrdersLoaded({required this.orders});
}

class OrdersError extends OrdersState {
  final String error;
  OrdersError(this.error);
}

class OrderDetailsLoading extends OrdersState {}

class OrderDetailsLoaded extends OrdersState {
  final OrderModel order;
  OrderDetailsLoaded({required this.order});
}

class OrderDetailsError extends OrdersState {
  final String error;
  OrderDetailsError(this.error);
}

class OrderCreated extends OrdersState {
  final OrderModel order;
  OrderCreated({required this.order});
}

class OrderCancelled extends OrdersState {}
