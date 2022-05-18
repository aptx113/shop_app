import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final cartItems = cartData.items.values.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cartData.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                ?.color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      child: const Text('ORDER NOW'),
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false)
                            .addOrder(cartItems, cartData.totalAmount);
                        cartData.clear();
                      },
                    )
                  ]),
            ),
          ),
          const SizedBox(height: 19),
          Expanded(
              child: ListView.builder(
            itemCount: cartData.items.length,
            itemBuilder: (context, i) => CartItem(
                id: cartItems[i].id,
                productID: cartData.items.keys.toList()[i],
                title: cartItems[i].title,
                quantity: cartItems[i].quantity,
                price: cartItems[i].price),
          ))
        ],
      ),
    );
  }
}
