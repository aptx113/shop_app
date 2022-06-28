import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/shop_drawer.dart';

import '../widgets/product_grid.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  late final _products;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _products = Provider.of<ProductsProvider>(context);
      setState(() {
        _isLoading = true;
      });
      _products.fetchAndSetProducts().then((_) {
        setState(() {});
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.favorites,
                    ),
                    const PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.all,
                    )
                  ],
              icon: const Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              }),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                    child: ch ??
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {},
                        ),
                    value: cart.items.length.toString(),
                  ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
      drawer: const ShopDrawer(),
    );
  }
}
