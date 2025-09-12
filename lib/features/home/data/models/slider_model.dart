class SliderModel {
  final int id;
  final String imageUrl;
  final String title;
  final String? description;

  SliderModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.description,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    print('Slider JSON: $json');
    // صحح الـ key عشان يبقى image_path مش image_url
    final imageUrl = json['image_path'] as String? ?? json['image_url'] as String? ?? json['imageUrl'] as String? ?? '';
    print('Slider Image URL: $imageUrl');
    return SliderModel(
      id: json['id'] as int,
      imageUrl: imageUrl,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imageUrl,
      'title': title,
      'description': description,
    };
  }
}