import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final int stock;
  final String categoryName;
  final int popularity;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.stock,
    required this.categoryName,
    required this.popularity,
  });

  factory Item.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      stock: data['stock'] ?? 0,
      categoryName: data['categoryId'] ?? '',
      popularity: data['popularity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'stock': stock,
      'categoryName': categoryName,
      'popularity': popularity,
    };
  }
}
