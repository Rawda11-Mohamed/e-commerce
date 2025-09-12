import 'package:bloc/bloc.dart';
import 'package:stylish_app/features/products/data/models/product_model.dart';
import 'package:stylish_app/features/products/data/models/category_model.dart';
import 'package:stylish_app/features/home/data/models/slider_model.dart';
import 'package:stylish_app/features/products/data/repos/products_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductsRepo _productsRepo;
  HomeCubit(this._productsRepo) : super(HomeInitial());

  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  List<ProductModel> _trendingProducts = [];
  List<SliderModel> _sliders = [];

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  List<ProductModel> get trendingProducts => _trendingProducts;
  List<SliderModel> get sliders => _sliders;

  void loadHomeData() async {
    print('[HomeCubit] Loading home data...');
    emit(HomeLoading());

    try {
      final slidersResult = await _productsRepo.getSliders();
      slidersResult.fold(
            (failure) {
          print('[HomeCubit] Error loading sliders: $failure');
          _sliders = [];
        },
            (sliders) {
          print('[HomeCubit] Loaded ${sliders.length} sliders');
          print('[HomeCubit] Sliders  $sliders');
          _sliders = sliders;
        },
      );

      final categoriesResult = await _productsRepo.getCategories();
      categoriesResult.fold(
            (failure) {
          print('[HomeCubit] Error loading categories: $failure');
          emit(HomeError(failure));
          return;
        },
            (categories) {
          print('[HomeCubit] Loaded ${categories.length} categories');
          _categories = categories;
        },
      );

      final trendingResult = await _productsRepo.getTrendingProducts();
      trendingResult.fold(
            (failure) {
          print('[HomeCubit] Error loading trending products: $failure');
          emit(HomeError(failure));
          return;
        },
            (trending) {
          print('[HomeCubit] Loaded ${trending.length} trending products');
          _trendingProducts = trending;
        },
      );

      final productsResult = await _productsRepo.getProducts(limit: 10);
      productsResult.fold(
            (failure) {
          print('[HomeCubit] Error loading products: $failure');
          emit(HomeError(failure));
          return;
        },
            (products) {
          print('[HomeCubit] Loaded ${products.length} products');
          _products = products;
        },
      );

      print('[HomeCubit] Emitting HomeLoaded with ${_products.length} products and ${_sliders.length} sliders');
      emit(HomeLoaded(
        products: _products,
        categories: _categories,
        trendingProducts: _trendingProducts,
        sliders: _sliders,
      ));
    } catch (e) {
      print('[HomeCubit] Exception: $e');
      emit(HomeError('Failed to load home  $e'));
    }
  }

  void searchProducts(String query) async {
    if (query.isEmpty) {
      loadHomeData();
      return;
    }

    emit(HomeLoading());

    final result = await _productsRepo.searchProducts(query);
    result.fold(
          (failure) {
        emit(HomeError(failure));
      },
          (products) {
        _products = products;
        emit(HomeLoaded(
          products: _products,
          categories: _categories,
          trendingProducts: _trendingProducts,
          sliders: _sliders,
        ));
      },
    );
  }

  void filterByCategory(String category) async {
    print('[HomeCubit] Filtering by category: $category');
    emit(HomeLoading());

    final result = await _productsRepo.getProducts(category: category);
    result.fold(
          (failure) {
        print('[HomeCubit] Filter error: $failure');
        emit(HomeError(failure));
      },
          (products) {
        print('[HomeCubit] Filtered ${products.length} products');
        _products = products;
        emit(HomeLoaded(
          products: _products,
          categories: _categories,
          trendingProducts: _trendingProducts,
          sliders: _sliders,
        ));
      },
    );
  }

  void toggleFavorite(int productId) async {
    bool currentStatus = false;
    bool found = false;

    for (var product in _trendingProducts) {
      if (product.id == productId) {
        currentStatus = product.isFavorite;
        found = true;
        break;
      }
    }

    if (!found) {
      for (var product in _products) {
        if (product.id == productId) {
          currentStatus = product.isFavorite;
          found = true;
          break;
        }
      }
    }

    if (!found) {
      return;
    }

    bool newStatus = !currentStatus;
    print('[HomeCubit] ${newStatus ? "Adding to" : "Removing from"} favorites');

    for (var product in _trendingProducts) {
      if (product.id == productId) {
        product.isFavorite = newStatus;
      }
    }
    for (var product in _products) {
      if (product.id == productId) {
        product.isFavorite = newStatus;
      }
    }

    emit(HomeLoaded(
      trendingProducts: _trendingProducts,
      products: _products,
      categories: _categories,
      sliders: _sliders,
    ));

    try {
      final result = await _productsRepo.updateFavoriteStatus(productId);
      result.fold(
            (failure) {
          print('[HomeCubit] Failed to update favorite status: $failure');
          for (var product in _trendingProducts) {
            if (product.id == productId) {
              product.isFavorite = currentStatus;
            }
          }
          for (var product in _products) {
            if (product.id == productId) {
              product.isFavorite = currentStatus;
            }
          }
          emit(HomeLoaded(
            trendingProducts: _trendingProducts,
            products: _products,
            categories: _categories,
            sliders: _sliders,
          ));
        },
            (serverStatus) {
          print('[HomeCubit] Server response: $serverStatus');
          // If server doesn't provide clear status, keep the optimistic update
          final finalStatus = serverStatus ?? newStatus;
          print('[HomeCubit] Final status: $finalStatus (server: $serverStatus, optimistic: $newStatus)');
          
          for (var product in _trendingProducts) {
            if (product.id == productId) {
              product.isFavorite = finalStatus;
            }
          }
          for (var product in _products) {
            if (product.id == productId) {
              product.isFavorite = finalStatus;
            }
          }
          emit(HomeLoaded(
            trendingProducts: _trendingProducts,
            products: _products,
            categories: _categories,
            sliders: _sliders,
          ));
        },
      );
    } catch (e) {
      print('[HomeCubit] Exception while updating favorite: $e');
      for (var product in _trendingProducts) {
        if (product.id == productId) {
          product.isFavorite = currentStatus;
        }
      }
      for (var product in _products) {
        if (product.id == productId) {
          product.isFavorite = currentStatus;
        }
      }
      emit(HomeLoaded(
        trendingProducts: _trendingProducts,
        products: _products,
        categories: _categories,
        sliders: _sliders,
      ));
    }
  }
}