import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)?.settings.arguments as String;
    final targetProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findByID(productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(targetProduct.title),
      ),
    );
  }
}