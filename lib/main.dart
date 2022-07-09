import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeData theme = ThemeData(
      primarySwatch: Colors.purple,
      fontFamily: 'Lato',
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      }));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (context) => ProductsProvider(),
            update: ((context, auth, previousProducts) {
              if (previousProducts != null) {
                return previousProducts
                  ..update(auth.token ?? '', previousProducts.items,
                      auth.userId ?? '');
              } else {
                return ProductsProvider();
              }
            })),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders(),
            update: (context, auth, previousOrders) {
              if (previousOrders != null) {
                return previousOrders
                  ..update(auth.token ?? '', previousOrders.orders,
                      auth.userId ?? '');
              } else {
                return Orders();
              }
            })
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'MyShop',
          theme: theme.copyWith(
              colorScheme:
                  theme.colorScheme.copyWith(secondary: Colors.deepOrange)),
          home: authData.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen()),
          routes: {
            ProductsOverviewScreen.routeName: ((context) =>
                const ProductsOverviewScreen()),
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen()
          },
        ),
      ),
    );
  }
}
