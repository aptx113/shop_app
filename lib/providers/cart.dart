import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
        ((key, cartItem) => total += cartItem.price * cartItem.quantity));
    return total;
  }

  void addItem(String productID, double price, String title) {
    if (_items.containsKey(productID)) {
      _items.update(
          productID,
          (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity + 1,
              price: existingItem.price));
    } else {
      _items.putIfAbsent(
          productID,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });

  final String id;
  final double price;
  final int quantity;
  final String title;
}
