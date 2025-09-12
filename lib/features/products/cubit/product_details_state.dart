import 'package:stylish_app/features/products/data/models/product_model.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductModel product;
  ProductDetailsLoaded({required this.product});
}

class ProductDetailsError extends ProductDetailsState {
  final String error;
  ProductDetailsError(this.error);
}

class ProductDetailsAddedToCart extends ProductDetailsState {}
