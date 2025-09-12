import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:stylish_app/features/orders/data/models/order_model.dart';
import 'package:stylish_app/features/orders/data/repos/orders_repo.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo _ordersRepo;
  int orderId;

  OrdersCubit(this._ordersRepo, this.orderId) : super(OrdersInitial());

  List<OrderModel> _orders = [];
  OrderModel? _selectedOrder;

  List<OrderModel> get orders => _orders;
  OrderModel? get selectedOrder => _selectedOrder;

  void loadOrders() async {
    emit(OrdersLoading());
    final result = await _ordersRepo.getOrders();
    result.fold(
          (failure) => emit(OrdersError(failure)),
          (orders) {
        _orders = orders;
        emit(OrdersLoaded(orders: _orders));
      },
    );
  }

  void loadOrderDetails(int orderId) async {
    if (orderId <= 0) {
      emit(OrderDetailsError('Invalid order ID.'));
      return;
    }

    emit(OrderDetailsLoading());

    final existingOrder = _orders.firstWhere(
          (order) => order.id == orderId,
      orElse: () => OrderModel(
        id: 0,
        orderNumber: '',
        items: [],
        subtotal: 0.0,
        tax: 0.0,
        deliveryFee: 0.0,
        total: 0.0,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      ),
    );

    if (existingOrder.id != 0) {
      _selectedOrder = existingOrder;
      emit(OrderDetailsLoaded(order: existingOrder));
      return;
    }

    final result = await _ordersRepo.getOrderDetails(orderId);
    result.fold(
          (failure) => emit(OrderDetailsError(failure)),
          (order) {
        _selectedOrder = order;
        emit(OrderDetailsLoaded(order: order));
      },
    );
  }

  void createOrder({
    required List<Map<String, dynamic>> items,
    required String shippingAddress,
    required String paymentMethod,
    String? notes,
  }) async {
    emit(OrdersLoading());

    final result = await _ordersRepo.createOrder(
      items: items,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      notes: notes,
    );

    result.fold(
          (failure) => emit(OrdersError(failure)),
          (order) {
        _orders.insert(0, order);
        emit(OrdersLoaded(orders: _orders));
        emit(OrderCreated(order: order));
      },
    );
  }

  void cancelOrder(int orderId) async {
    emit(OrdersLoading());

    try {
      final result = await _ordersRepo.cancelOrder(orderId);

      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: OrderStatus.cancelled,
          updatedAt: DateTime.now(),
        );
      }

      if (_selectedOrder?.id == orderId) {
        _selectedOrder = _selectedOrder!.copyWith(
          status: OrderStatus.cancelled,
          updatedAt: DateTime.now(),
        );
      }

      emit(OrdersLoaded(orders: _orders));
      emit(OrderCancelled());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        emit(OrderDetailsError('Order not found or already cancelled.'));
      } else if (e.response?.statusCode == 409) {
        emit(OrderDetailsError('Order cannot be cancelled at this status.'));
      } else if (e.response?.statusCode == 403) {
        emit(OrderDetailsError('You are not authorized to cancel this order.'));
      } else {
        emit(OrderDetailsError('Failed to cancel order. Please try again later.'));
      }
    } catch (e) {
      emit(OrderDetailsError('An unexpected error occurred.'));
    }
  }
}