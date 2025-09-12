import 'package:bloc/bloc.dart';
import 'package:stylish_app/features/cart/data/models/cart_item_model.dart';
import 'cart_state.dart';
import 'package:stylish_app/features/products/data/models/product_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  List<CartItemModel> _cartItems = [];
  double _subtotal = 0.0;
  double _tax = 0.0;
  double _deliveryFee = 0.0;
  double _total = 0.0;

  List<CartItemModel> get cartItems => _cartItems;
  double get subtotal => _subtotal;
  double get tax => _tax;
  double get deliveryFee => _deliveryFee;
  double get total => _total;

  void loadCart() {
    emit(CartLoading());
    _calculateTotals();
    emit(CartLoaded(cartItems: List.from(_cartItems)));
  }

  void addToCart(ProductModel product, int quantity) {
    emit(CartLoading());

    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      final updatedItem = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
        totalPrice: product.price * (_cartItems[existingIndex].quantity + quantity),
      );
      _cartItems[existingIndex] = updatedItem;
    } else {
      final newItem = CartItemModel(
        id: _cartItems.isEmpty ? 1 : _cartItems.last.id + 1,
        product: product,
        quantity: quantity,
        totalPrice: product.price * quantity,
      );
      _cartItems.add(newItem);
    }

    _calculateTotals();
    emit(CartLoaded(cartItems: List.from(_cartItems)));
  }

  void updateQuantity(int cartItemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(cartItemId);
      return;
    }

    emit(CartLoading());

    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: quantity,
        totalPrice: _cartItems[index].product.price * quantity,
      );
      _calculateTotals();
      emit(CartLoaded(cartItems: List.from(_cartItems)));
    }
  }

  void removeFromCart(int cartItemId) {
    emit(CartLoading());
    _cartItems.removeWhere((item) => item.id == cartItemId);
    _calculateTotals();
    emit(CartLoaded(cartItems: List.from(_cartItems)));
  }

  void clearCart() {
    emit(CartLoading());
    _cartItems.clear();
    _calculateTotals();
    emit(CartLoaded(cartItems: List.from(_cartItems)));
  }

  void _calculateTotals() {
    _subtotal = _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    _tax = _subtotal * 0.1;
    _deliveryFee = _subtotal > 50 ? 0.0 : 2.0;
    _total = _subtotal + _tax + _deliveryFee;
  }
}