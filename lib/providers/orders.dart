import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  String _authToken = '';
  String _userId = '';

  List<Order> get orders => [..._orders];

  void update(String token, List<Order> orders, String userId) {
    _authToken = token;
    _orders = orders;
    _userId = userId;
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://my-flutter-demo-f90d8-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken');
    final response = await http.get(url);
    List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(Order(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://my-flutter-demo-f90d8-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken');
    final timestamp = DateTime.now();
    final body = {
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts
          .map((cartProduct) => {
                'id': cartProduct.id,
                'title': cartProduct.title,
                'quantity': cartProduct.quantity,
                'price': cartProduct.price
              })
          .toList()
    };

    try {
      final response = await http.post(url, body: json.encode(body));
      final responseId = json.decode(response.body)['name'];
      _orders.insert(
          0,
          Order(
              id: responseId,
              amount: total,
              dateTime: timestamp,
              products: cartProducts));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
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
