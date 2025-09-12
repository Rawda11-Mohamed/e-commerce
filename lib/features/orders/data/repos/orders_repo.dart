import 'package:dartz/dartz.dart';
import 'package:stylish_app/core/api/api_helper.dart';
import 'package:stylish_app/core/api/api_response.dart';
import 'package:stylish_app/core/api/end_points.dart';
import 'package:stylish_app/features/orders/data/models/order_model.dart';

class OrdersRepo {
  final ApiHelper apiHelper;
  OrdersRepo({required this.apiHelper});

  Future<Either<String, List<OrderModel>>> getOrders() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.getOrders,
        isProtected: true,
      );

      if (response.status) {
        final raw = response.data;

        // Normalize to a List<dynamic> of orders
        List<dynamic> ordersList = [];

        if (raw is Map<String, dynamic>) {
          // Some APIs return grouped orders e.g., { orders: { active: [], canceled: [], completed: [] } }
          if (raw['orders'] is Map<String, dynamic>) {
            final ordersMap = raw['orders'] as Map<String, dynamic>;
            for (var key in ['active', 'canceled', 'completed', 'pending', 'processing', 'shipped', 'delivered']) {
              if (ordersMap[key] is List) {
                ordersList.addAll(ordersMap[key] as List);
              }
            }
          }

          // Flat list under 'orders'
          if (ordersList.isEmpty && raw['orders'] is List) {
            ordersList = (raw['orders'] as List);
          }

          // Flat list under 'data'
          if (ordersList.isEmpty && raw['data'] is List) {
            ordersList = (raw['data'] as List);
          }
        }

        // Response is already a list
        if (ordersList.isEmpty && raw is List) {
          ordersList = raw;
        }

        final orders = ordersList.map((json) => OrderModel.fromJson(json as Map<String, dynamic>)).toList();
        return Right(orders);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, OrderModel>> getOrderDetails(int orderId) async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.getOrders,
        queryParameters: {'order_id': orderId},
        isProtected: true,
      );

      if (response.status) {
        final raw = response.data;

        Map<String, dynamic>? orderMap;
        if (raw is Map<String, dynamic>) {
          if (raw['data'] is Map<String, dynamic>) {
            orderMap = raw['data'] as Map<String, dynamic>;
          } else if (raw['order'] is Map<String, dynamic>) {
            orderMap = raw['order'] as Map<String, dynamic>;
          } else {
            orderMap = raw;
          }
        }

        if (orderMap == null) {
          return Left('Invalid response format for order details');
        }

        final order = OrderModel.fromJson(orderMap);
        return Right(order);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, OrderModel>> createOrder({
    required List<Map<String, dynamic>> items,
    required String shippingAddress,
    required String paymentMethod,
    String? notes,
  }) async {
    try {
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.placeOrder,
        data: {
          'items': items,
          'shipping_address': shippingAddress,
          'payment_method': paymentMethod,
          'notes': notes,
        },
        isProtected: true,
        isFormData: false,
      );

      if (response.status) {
        final raw = response.data;

        Map<String, dynamic> orderData;
        if (raw is Map<String, dynamic>) {
          if (raw.containsKey('data')) {
            orderData = raw['data'] is Map<String, dynamic>
                ? raw['data'] as Map<String, dynamic>
                : raw;
          } else {
            orderData = raw;
          }
        } else {
          orderData = {
            'order_id': raw['order_id'] ?? 0,
            'total': raw['total'] ?? 0.0,
            'status': 'pending',
            'created_at': DateTime.now().toIso8601String(),
          };
        }

        orderData['id'] = orderData['id'] ?? orderData['order_id'] ?? 0;
        orderData['order_number'] = orderData['order_number'] ?? 'ORD-${DateTime.now().millisecondsSinceEpoch}';
        orderData['items'] = orderData['items'] ?? [];
        orderData['subtotal'] = orderData['subtotal'] ?? orderData['total'] ?? 0.0;
        orderData['tax'] = orderData['tax'] ?? 0.0;
        orderData['delivery_fee'] = orderData['delivery_fee'] ?? 0.0;
        orderData['total'] = orderData['total'] ?? 0.0;
        orderData['status'] = orderData['status'] ?? 'pending';
        orderData['created_at'] = orderData['created_at'] ?? DateTime.now().toIso8601String();

        OrderModel order = OrderModel.fromJson(orderData);
        return Right(order);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, Unit>> cancelOrder(int orderId) async {
    try {
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.cancelOrder,
        data: {
          'order_id': orderId,
        },
        isProtected: true,
      );

      if (response.status) {
        return Right(unit);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}