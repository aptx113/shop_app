import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

class Orders with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [...orders];

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        Order(
            id: DateTime.now().toString(),
            amount: total,
            dateTime: DateTime.now(),
            products: cartProducts));
    notifyListeners();
  }
}

class Order {
  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  final double amount;
  final DateTime dateTime;
  final String id;
  final List<CartItem> products;
}
