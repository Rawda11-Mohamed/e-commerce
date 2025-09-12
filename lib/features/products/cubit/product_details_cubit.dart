import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_app/features/home/cubit/home_cubit.dart';
import 'package:stylish_app/features/products/data/models/product_model.dart';
import 'package:stylish_app/features/products/data/repos/products_repo.dart';
import 'package:stylish_app/features/cart/cubit/cart_cubit.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductsRepo _productsRepo;
  ProductDetailsCubit(this._productsRepo) : super(ProductDetailsInitial());

  ProductModel? _product;
  int _quantity = 1;

  ProductModel? get product => _product;
  int get quantity => _quantity;

  void loadProductDetails(int productId) async {
    emit(ProductDetailsLoading());

    try {
      final result = await _productsRepo.getProductDetails(productId);
      result.fold(
            (failure) {
          emit(ProductDetailsError(failure));
        },
            (product) {
          _product = product;
          _quantity = 1;
          emit(ProductDetailsLoaded(product: product));
        },
      );
    } catch (e) {
      emit(ProductDetailsError('Failed to load product details: $e'));
    }
  }

  void increaseQuantity() {
    if (_product != null && _quantity < _product!.stock) {
      _quantity++;
      emit(ProductDetailsLoaded(product: _product!));
    }
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      emit(ProductDetailsLoaded(product: _product!));
    }
  }

  void toggleFavorite(context) async {
    if (_product == null) return;

    final originalProduct = _product!;
    final bool previousFavoriteStatus = originalProduct.isFavorite;

    _product = _product!.copyWith(isFavorite: !previousFavoriteStatus);
    emit(ProductDetailsLoaded(product: _product!));

    try {
      final result = await _productsRepo.updateFavoriteStatus(originalProduct.id);

      result.fold(
            (failure) {
          print('[ProductDetailsCubit] Failed to update favorite: $failure');
          _product = originalProduct;
          emit(ProductDetailsLoaded(product: _product!));
        },
            (serverStatus) {
          print('[ProductDetailsCubit] Server response: $serverStatus');
          // If server provides explicit status, use it; otherwise keep optimistic update
          if (serverStatus != null) {
            _product = _product!.copyWith(isFavorite: serverStatus);
            emit(ProductDetailsLoaded(product: _product!));
          }
          
          try {
            final homeCubit = context.read<HomeCubit?>();
            if (homeCubit != null) {
              homeCubit.toggleFavorite(originalProduct.id);
            }
          } catch (e) {
            print('[ProductDetailsCubit] Could not notify HomeCubit: $e');
          }
        },
      );
    } catch (e) {
      _product = originalProduct;
      emit(ProductDetailsLoaded(product: _product!));
    }
  }

  void addToCart(BuildContext context, int quantity) {
    if (_product == null) return;
    context.read<CartCubit>().addToCart(_product!, quantity);
    emit(ProductDetailsAddedToCart());
    emit(ProductDetailsLoaded(product: _product!));
  }
}