import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavValue() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    toggleFavValue();
    final url = Uri.parse(
      'https://flutter-shop-71da1-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token',
    );
    try {
      await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
    } catch (e) {
      toggleFavValue();
      throw ErrorDescription('Could not update favorite status');
    }
  }

  @override
  String toString() {
    return '$id $title $description $price $imageUrl';
  }

  static String encode(Product p, String userId) => json.encode({
        'title': p.title,
        'description': p.description,
        'imageUrl': p.imageUrl,
        'price': p.price,
        'creatorId': userId
      });
}
