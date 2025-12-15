class Vendor {
  final String id;
  final String name;
  final String? organ; // Make nullable
  final String? email; // Make nullable
  final String? website; // Make nullable
  final String? address; // Make nullable
  final String? logo; // Make nullable
  final List<String> phones;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vendor({
    required this.id,
    required this.name,
    this.organ, // Already nullable
    this.email, // Already nullable
    this.website, // Already nullable
    this.address, // Already nullable
    this.logo, // Already nullable
    this.phones = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id']?.toString() ?? '', // Handle null ID
      name: json['name']?.toString() ?? 'Unknown Vendor', // Default value
      organ: json['organ']?.toString(), // Will be null if missing
      email: json['email']?.toString(),
      website: json['website']?.toString(),
      address: json['address']?.toString(),
      logo: json['logo']?.toString(),
      phones: _parsePhones(json['phones']), // Helper method
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static List<String> _parsePhones(dynamic phones) {
    if (phones == null) return [];
    if (phones is String) return [phones];
    if (phones is List) {
      return phones.map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  static DateTime _parseDateTime(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organ': organ,
      'email': email,
      'website': website,
      'address': address,
      'logo': logo,
      'phones': phones,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}