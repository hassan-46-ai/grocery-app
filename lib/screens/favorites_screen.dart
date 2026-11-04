import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/product_widgets.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final favs = s.favoriteProducts;

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: favs.isEmpty
          ? const EmptyState(emoji: '💚', title: 'No favourites yet', subtitle: 'Tap the heart on any product to save it here.')
          : Column(
              children: [
                Expanded(child: ProductGrid(products: favs, scrollable: true)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: PrimaryButton(
                    label: 'Add All To Cart',
                    onPressed: () {
                      s.addAllFavoritesToCart();
                      context.snack('${favs.length} items added to cart');
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
