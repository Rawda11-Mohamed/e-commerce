import 'package:stylish_app/features/products/data/models/product_model.dart';

class CartItemModel {
  final int id;
  final ProductModel product;
  final int quantity;
  final double totalPrice;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Handle different API response structures
    ProductModel product;
    if (json['product'] is Map<String, dynamic>) {
      // If product is a nested object
      product = ProductModel.fromJson(json['product']);
    } else {
      // If product data is flat in the item
      product = ProductModel(
        id: json['product_id'] ?? json['id'] ?? 0,
        name: json['product_name'] ?? json['name'] ?? 'Unknown Product',
        description: json['product_description'] ?? json['description'] ?? '',
        price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
        imageUrl: json['product_image'] ?? json['image_url'] ?? json['image_path'] ?? '',
        category: json['product_category'] ?? json['category'] ?? '',
        rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
        reviewCount: int.tryParse(json['review_count']?.toString() ?? '0') ?? 0,
        isFavorite: json['is_favorite'] == true || json['is_favorite'] == '1',
        stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      );
    }

    return CartItemModel(
      id: json['id'] ?? json['item_id'] ?? 0,
      product: product,
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }

  CartItemModel copyWith({
    int? id,
    ProductModel? product,
    int? quantity,
    double? totalPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
