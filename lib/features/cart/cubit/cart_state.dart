import 'package:stylish_app/features/cart/data/models/cart_item_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> cartItems;
  CartLoaded({required this.cartItems});
}

class CartError extends CartState {
  final String error;
  CartError(this.error);
}
