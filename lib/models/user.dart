import 'package:e_commerce_demo/models/items.dart';
import 'package:e_commerce_demo/models/wishlist.dart';

class UserModel {
  final String id; // User ID
  final String name; // User name
  final String email; // User email
  final List<Item> favorites; // List of favorite items
  final List<Item> cart; // List of items in the cart
  final List<Item> boughtItems; // List of bought items
  final List<Wishlist> wishlists; // List of user's wishlists

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.favorites = const [], // Default to an empty list
    this.cart = const [], // Default to an empty list
    this.boughtItems = const [], // Default to an empty list
    this.wishlists = const [], // Default to an empty list
  });

  // Convert UserModel object to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'favorites': favorites.map((item) => item.toMap()).toList(),
      'cart': cart.map((item) => item.toMap()).toList(),
      'boughtItems': boughtItems.map((item) => item.toMap()).toList(),
      'wishlists': wishlists.map((wishlist) => wishlist.toJson()).toList(),
    };
  }

  // Create UserModel object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      favorites: (json['favorites'] as List)
          .map((item) => Item.fromDocument(item))
          .toList(),
      cart: (json['cart'] as List)
          .map((item) => Item.fromDocument(item))
          .toList(),
      boughtItems: (json['boughtItems'] as List)
          .map((item) => Item.fromDocument(item))
          .toList(),
      wishlists: (json['wishlists'] as List)
          .map((wishlist) => Wishlist.fromJson(wishlist))
          .toList(),
    );
  }
}
