import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

import './providers/products_provider.dart';
import './screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeData theme =
      ThemeData(primarySwatch: Colors.purple, fontFamily: 'Lato');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: theme.copyWith(
            colorScheme:
                theme.colorScheme.copyWith(secondary: Colors.deepOrange)),
        initialRoute: '/',
        routes: {
          '/': (context) => const ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
        },
      ),
    );
  }
}
