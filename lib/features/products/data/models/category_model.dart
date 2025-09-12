class CategoryModel {
  final int id;
  final String name;
  final String imageUrl;
  final int productCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.productCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['title'] ?? json['name'] ?? '',
      imageUrl: json['image_path'] ?? json['image_url'] ?? '',
      productCount: json['product_count'] ?? (json['products'] as List?)?.length ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'product_count': productCount,
    };
  }
}
