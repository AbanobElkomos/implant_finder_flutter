class Vendor {
  final String id;
  final DateTime createdAt;
  final String name;
  final String? logo;
  final String? website;
  final String? email;
  final List<String> phone;
  final String? address;
  final String? organ;

  Vendor({
    required this.id,
    required this.createdAt,
    required this.name,
    this.logo,
    this.website,
    this.email,
    this.phone = const [],
    this.address,
    this.organ,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      name: json['name'] as String,
      logo: json['logo'] as String?,
      website: json['website'] as String?,
      email: json['email'] as String?,
      phone: _parsePhoneArray(json['phone']),
      address: json['address'] as String?,
      organ: json['organ'] as String?,
    );
  }

  static List<String> _parsePhoneArray(dynamic phoneData) {
    if (phoneData == null) return [];

    if (phoneData is List) {
      return List<String>.from(phoneData);
    } else if (phoneData is String) {
      final cleaned = phoneData
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll('"', '');
      if (cleaned.isNotEmpty) {
        return cleaned.split(',').map((s) => s.trim()).toList();
      }
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'logo': logo,
      'website': website,
      'email': email,
      'phone': phone,
      'address': address,
      'organ': organ,
    };
  }

  Vendor copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? logo,
    String? website,
    String? email,
    List<String>? phone,
    String? address,
    String? organ,
  }) {
    return Vendor(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      website: website ?? this.website,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      organ: organ ?? this.organ,
    );
  }

  @override
  String toString() => 'Vendor(id: $id, name: $name, country: $organ)';
}