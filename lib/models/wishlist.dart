import 'package:e_commerce_demo/models/items.dart';

class Wishlist {
  final String id; // Wishlist ID
  final String userId; // User ID
  final String name; // Wishlist name
  final List<Item> items; // List of items in the wishlist

  Wishlist({
    required this.id,
    required this.userId, // User ID associated with the wishlist
    required this.name,
    this.items = const [], // Default to an empty list
  });

  // Convert Wishlist object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // Create Wishlist object from JSON
  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      items: (json['items'] as List)
          .map((item) => Item.fromDocument(item))
          .toList(),
    );
  }
}
