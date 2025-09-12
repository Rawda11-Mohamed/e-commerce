class ProfileModel {
  final String name;
  final String? phone;

  ProfileModel({
    required this.name,
    this.phone,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle different API response structures
    String name = '';
    String? phone;
    
    if (json['data'] is Map<String, dynamic>) {
      // If response is wrapped in 'data' field
      final data = json['data'] as Map<String, dynamic>;
      name = data['name']?.toString() ?? '';
      phone = data['phone']?.toString();
    } else {
      // If response is flat
      name = json['name']?.toString() ?? '';
      phone = json['phone']?.toString();
    }
    
    // Clean up phone number (remove null if empty string)
    if (phone != null && phone.isEmpty) {
      phone = null;
    }
    
    return ProfileModel(
      name: name,
      phone: phone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }

  ProfileModel copyWith({
    String? name,
    String? phone,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}