import 'package:stylish_app/features/products/data/models/product_model.dart';
import 'package:stylish_app/features/products/data/models/category_model.dart';
import 'package:stylish_app/features/home/data/models/slider_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final List<ProductModel> trendingProducts;
  final List<SliderModel> sliders;

  HomeLoaded({
    required this.products,
    required this.categories,
    required this.trendingProducts,
    required this.sliders,
  });
}

class HomeError extends HomeState {
  final String error;
  HomeError(this.error);
}