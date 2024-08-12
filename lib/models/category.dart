class Category {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final int itemCount;
  final bool isFeatured;
  final String type; // e.g., 'car', 'bike', 'accessory'

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.itemCount,
    required this.isFeatured,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'itemCount': itemCount,
      'isFeatured': isFeatured,
      'type': type,
    };
  }

  static Category fromMap(String id, Map<String, dynamic> map) {
    return Category(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      itemCount: map['itemCount'] ?? 0,
      isFeatured: map['isFeatured'] ?? false,
      type: map['type'] ?? '',
    );
  }
}
//import 'package:cloud_firestore/cloud_firestore.dart';
