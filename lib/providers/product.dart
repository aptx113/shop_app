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

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://my-flutter-demo-f90d8-default-rtdb.firebaseio.com/products/$id.json');
    final body = {'isFavorite': isFavorite};

    try {
      final response = await http.patch(url, body: json.encode(body));
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (e) {
      _setFavoriteValue(oldStatus);
    }
  }
}
