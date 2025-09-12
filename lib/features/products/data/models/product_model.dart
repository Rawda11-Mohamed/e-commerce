class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  bool isFavorite;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    this.isFavorite = false,
    required this.stock,
  });

  // Factory method for empty product
  factory ProductModel.empty() {
    return ProductModel(
      id: 0,
      name: '',
      description: '',
      price: 0.0,
      imageUrl: '',
      category: '',
      rating: 0.0,
      reviewCount: 0,
      isFavorite: false,
      stock: 0,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    print('ProductModel.fromJson input: ' + json.toString());
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price'] == null
          ? 0.0
          : double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['image_path'] ?? json['image_url'] ?? '',
      category: json['category'] is Map
          ? (json['category']['title'] ??
          json['category']['name'] ??
          '')
          .toString()
          : json['category']?.toString() ?? '',
      rating: json['rating'] == null
          ? 0.0
          : double.tryParse(json['rating'].toString()) ?? 0.0,
      reviewCount: json['review_count'] == null
          ? 0
          : int.tryParse(json['review_count'].toString()) ?? 0,

      isFavorite: json['is_favorite'] == null
          ? false
          : (json['is_favorite'] is bool
          ? json['is_favorite'] as bool
          : (json['is_favorite'].toString() == '1' ||
          json['is_favorite'].toString().toLowerCase() == 'true')),

      stock: json['stock'] == null
          ? 0
          : int.tryParse(json['stock'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'rating': rating,
      'review_count': reviewCount,
      'is_favorite': isFavorite,
      'stock': stock,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    int? stock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      stock: stock ?? this.stock,
    );
  }
}