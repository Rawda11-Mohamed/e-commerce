import 'package:dartz/dartz.dart';
import 'package:stylish_app/core/api/api_helper.dart';
import 'package:stylish_app/core/api/api_response.dart';
import 'package:stylish_app/core/api/end_points.dart';
import 'package:stylish_app/features/products/data/models/product_model.dart';
import 'package:stylish_app/features/products/data/models/category_model.dart';
import 'package:stylish_app/features/home/data/models/slider_model.dart';

class ProductsRepo {
  final ApiHelper apiHelper;
  ProductsRepo({required this.apiHelper});

  Future<Either<String, List<ProductModel>>> getProducts({
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;

      var response = await apiHelper.getRequest(
        endPoint: EndPoints.getProducts,
        queryParameters: queryParams,
        isProtected: true,
      );

      if (response.status) {
        List<dynamic> productsJson = response.data['products'] ?? [];
        List<ProductModel> products = productsJson
            .map((json) {
          if (json is Map<dynamic, dynamic>) {
            return ProductModel.fromJson(json.cast<String, dynamic>());
          }
          return ProductModel.fromJson({});
        })
            .toList();
        return Right(products);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, ProductModel>> getProductDetails(int productId) async {
    try {
      final result = await getProducts();

      return result.fold(
            (error) => Left(error),
            (products) {
          final product = products.firstWhere(
                (p) => p.id == productId,
            orElse: () => ProductModel.empty(),
          );

          if (product.id == 0) {
            return Left("Product not found");
          }

          return Right(product);
        },
      );
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, List<CategoryModel>>> getCategories() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.getCategories,
        isProtected: true,
      );

      if (response.status) {
        List<dynamic> categoriesJson = response.data['categories'] ?? [];
        List<CategoryModel> categories = categoriesJson
            .map((json) {
          if (json is Map<dynamic, dynamic>) {
            return CategoryModel.fromJson(json.cast<String, dynamic>());
          }
          return CategoryModel.fromJson({});
        })
            .toList();
        return Right(categories);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, List<ProductModel>>> getTrendingProducts() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.topRatedProducts,
        isProtected: true,
      );

      if (response.status) {
        List<dynamic> productsJson = response.data['products'] ?? [];
        List<ProductModel> products = productsJson
            .map((json) {
          if (json is Map<dynamic, dynamic>) {
            return ProductModel.fromJson(json.cast<String, dynamic>());
          }
          return ProductModel.fromJson({});
        })
            .toList();
        return Right(products);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, List<ProductModel>>> searchProducts(String query) async {
    try {
      print('Searching for: $query');
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.searchProducts,
        queryParameters: {'q': query},
        isProtected: true,
      );

      print('Search response status: ${response.status}');
      print('Search response data: ${response.data}');

      if (response.status) {
        // Support multiple response shapes: {products: []} or {data: []} or []
        dynamic raw = response.data;
        List<dynamic> productsJson = [];
        if (raw is Map && raw['products'] is List) {
          productsJson = raw['products'] as List;
        } else if (raw is Map && raw['data'] is List) {
          productsJson = raw['data'] as List;
        } else if (raw is List) {
          productsJson = raw;
        }
        List<ProductModel> products = productsJson
            .map((json) {
          if (json is Map<dynamic, dynamic>) {
            return ProductModel.fromJson(json.cast<String, dynamic>());
          }
          return ProductModel.fromJson({});
        })
            .toList();
        print('Found ${products.length} products');
        return Right(products);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      print('Exception in searchProducts: $e');
      return Left(ApiResponse.fromError(e).message);
    }
  }

  // Returns new favorite status (true if now favorite, false if removed)
  Future<Either<String, bool>> updateFavoriteStatus(int productId) async {
    try {
      print('Toggling favorite status for product ID: $productId');
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.addToFavorite,
        data: {'product_id': productId},
        isProtected: true,
      );

      print('Update favorite response status: ${response.status}');
      print('Update favorite response data: ${response.data}');

      if (response.status) {
        // Try to read explicit flag from response
        if (response.data is Map) {
          final map = response.data as Map;

          // Check for explicit is_favorite flag
          if (map['is_favorite'] is bool) {
            print('Found explicit is_favorite flag: ${map['is_favorite']}');
            return Right(map['is_favorite'] as bool);
          }

          // Check nested data field
          if (map['data'] is Map) {
            final data = map['data'] as Map;
            if (data['is_favorite'] is bool) {
              print('Found nested is_favorite flag: ${data['is_favorite']}');
              return Right(data['is_favorite'] as bool);
            }
          }

          // Check for success message patterns
          final msg = (map['message'] ?? map['status'] ?? '').toString().toLowerCase();
          print('Response message: $msg');
          
          if (msg.contains('removed') || msg.contains('deleted') || msg.contains('unfavorited')) {
            print('Detected removal from message');
            return Right(false);
          }
          if (msg.contains('added') || msg.contains('favorit') || msg.contains('success')) {
            print('Detected addition from message');
            return Right(true);
          }
          print('No clear status indication, returning null for caller to handle');
          return Right(true);
        }

        print('Response is not a map, returning null for caller to handle');
        return Right(true);
      } else {
        return Left(response.message ?? 'Failed to update favorite status');
      }
    } catch (e) {
      print('Exception in updateFavoriteStatus: $e');
      return Left(ApiResponse.fromError(e).message);
    }
  }
  Future<Either<String, List<SliderModel>>> getSliders() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: 'sliders',
        isProtected: false,
      );

      if (response.status) {
        List<dynamic> slidersJson = [];

        if (response.data is List) {
          slidersJson = response.data as List;
        } else if (response.data is Map) {
          if (response.data['sliders'] is List) {
            slidersJson = response.data['sliders'] as List;
          } else if (response.data['data'] is List) {
            slidersJson = response.data['data'] as List;
          }
        }

        List<SliderModel> sliders = slidersJson
            .map((json) {
          if (json is Map<dynamic, dynamic>) {
            return SliderModel.fromJson(json.cast<String, dynamic>());
          }
          return SliderModel.fromJson({});
        })
            .toList();
        return Right(sliders);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}