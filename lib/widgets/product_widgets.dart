import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/app_image.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../data/models.dart';
import '../screens/category_products_screen.dart';
import '../screens/product_detail_screen.dart';
import '../state/app_state.dart';
import 'common.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final state = context.read<AppState>();
    final fav = context.select<AppState, bool>((s) => s.isFavorite(product.id));
    final qty = context.select<AppState, int>((s) => s.qtyOf(product.id));

    return TapScale(
      onTap: () => context.push(ProductDetailScreen(product: product)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: pal.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: pal.border.withOpacity(0.6)),
          boxShadow: [BoxShadow(color: pal.shadow, blurRadius: 14, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 104,
              width: double.infinity,
              decoration: BoxDecoration(color: pal.tile, borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: Material(type: MaterialType.transparency, child: ProductImage(product, size: 84)),
                    ),
                  ),
                  PositionedDirectional(
                    top: 2,
                    end: 2,
                    child: HeartButton(active: fav, onTap: () => state.toggleFavorite(product.id)),
                  ),
                  if (product.discountPercent > 0)
                    PositionedDirectional(
                      top: 8,
                      start: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                        child: Text('-${product.discountPercent}%',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(product.nameIn(context),
                maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.25)),
            const SizedBox(height: 2),
            Text(product.weightIn(context), style: TextStyle(color: pal.subtext, fontSize: 11)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(text: money(context, product.price), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: money(context, product.oldPrice),
                        style: TextStyle(fontSize: 10, color: pal.subtext, decoration: TextDecoration.lineThrough),
                      ),
                    ]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  height: 30,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOutBack,
                    transitionBuilder: (c, a) => ScaleTransition(
                      scale: a,
                      alignment: AlignmentDirectional.centerEnd.resolve(Directionality.of(context)),
                      child: c,
                    ),
                    layoutBuilder: (cur, prev) =>
                        Stack(alignment: AlignmentDirectional.centerEnd, children: [...prev, if (cur != null) cur]),
                    child: qty == 0
                        ? _AddButton(key: const ValueKey('add'), onTap: () => state.addToCart(product))
                        : _MiniStepper(key: const ValueKey('step'), qty: qty, onChanged: (v) => state.setQty(product.id, v)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
        child: const Tr('Add', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _MiniStepper extends StatelessWidget {
  const _MiniStepper({super.key, required this.qty, required this.onChanged});
  final int qty;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData i, VoidCallback f) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: f,
          child: SizedBox(width: 22, height: 30, child: Icon(i, size: 16, color: Colors.white)),
        );
    return Container(
      height: 30,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(Icons.remove, () => onChanged(qty - 1)),
          Text('$qty', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          btn(Icons.add, () => onChanged(qty + 1)),
        ],
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products, this.scrollable = false});
  final List<Product> products;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: !scrollable,
      physics: scrollable ? null : const NeverScrollableScrollPhysics(),
      padding: scrollable ? const EdgeInsets.fromLTRB(12, 4, 12, 20) : EdgeInsets.zero,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.64,
      ),
      itemBuilder: (_, i) => Reveal(index: i, child: ProductCard(product: products[i])),
    );
  }
}

class HorizontalProducts extends StatelessWidget {
  const HorizontalProducts({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 258,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => Reveal(
          index: i,
          offset: const Offset(0.2, 0),
          child: SizedBox(width: 168, child: ProductCard(product: products[i])),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: () => context.push(CategoryProductsScreen(category: category)),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(color: context.pal.tile, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: CategoryImage(category, size: 52),              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(category.nameIn(context),
              maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, height: 1.2)),
        ],
      ),
    );
  }
}
