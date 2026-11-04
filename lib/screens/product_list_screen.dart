import 'package:flutter/material.dart';

import '../data/models.dart';
import '../widgets/product_widgets.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key, required this.title, required this.products});
  final String title;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ProductGrid(products: products, scrollable: true),
    );
  }
}
