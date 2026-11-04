import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../data/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/product_widgets.dart';

/// Left sidebar of sub-categories + product grid (like the "Atta, Rice & Dal" design).
class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.category});
  final Category category;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late String _sub = widget.category.subs.first.name;
  bool _searching = false;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final state = context.read<AppState>();
    var products = state.productsIn(widget.category.name, _sub);
    if (_query.isNotEmpty) {
      products = state.productsIn(widget.category.name, _sub).where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(_searching ? Icons.close : Icons.search, key: ValueKey(_searching)),
            ),
            onPressed: () => setState(() {
              _searching = !_searching;
              if (!_searching) _query = '';
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: _searching
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: TextField(
                      autofocus: true,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: const InputDecoration(hintText: 'Search in this category', prefixIcon: Icon(Icons.search)),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 88,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
                    children: [
                      for (final sub in widget.category.subs)
                        GestureDetector(
                          onTap: () => setState(() => _sub = sub.name),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _sub == sub.name ? pal.primarySoft : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _sub == sub.name ? AppColors.primary : Colors.transparent),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 54,
                                  width: double.infinity,
                                  decoration: BoxDecoration(color: pal.tile, borderRadius: BorderRadius.circular(10)),
                                  child: Center(child: Text(sub.emoji, style: const TextStyle(fontSize: 28))),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  sub.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10.5, fontWeight: _sub == sub.name ? FontWeight.w700 : FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (c, a) => FadeTransition(opacity: a, child: c),
                    child: products.isEmpty
                        ? const EmptyState(key: ValueKey('empty'), emoji: '🔍', title: 'Nothing found', subtitle: 'Try another search.')
                        : ProductGridInPanel(key: ValueKey('$_sub$_query'), products: products),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Same grid as [ProductGrid] but with tighter padding for the narrow right panel.
class ProductGridInPanel extends StatelessWidget {
  const ProductGridInPanel({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 20),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.56,
      ),
      itemBuilder: (_, i) => Reveal(index: i, child: ProductCard(product: products[i])),
    );
  }
}
