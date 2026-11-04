import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../data/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final state = context.read<AppState>();
    final fav = context.select<AppState, bool>((s) => s.isFavorite(widget.product.id));
    final p = widget.product;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(color: pal.tile, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32))),
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: 'product-${p.id}',
                      child: Material(type: MaterialType.transparency, child: Text(p.emoji, style: const TextStyle(fontSize: 130))),
                    ),
                  ),
                  Positioned(left: 8, top: 4, child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
                  Positioned(right: 12, top: 8, child: HeartButton(active: fav, size: 26, onTap: () => state.toggleFavorite(p.id))),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Reveal(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(p.weight, style: TextStyle(color: pal.subtext)),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QtyControl(qty: _qty, onChanged: (v) => setState(() => _qty = v < 1 ? 1 : v)),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (c, a) => FadeTransition(opacity: a, child: SlideTransition(position: Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(a), child: c)),
                          child: Text.rich(
                            key: ValueKey(_qty),
                            TextSpan(children: [
                              TextSpan(text: money(p.price * _qty), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                              TextSpan(text: '  ${money(p.oldPrice * _qty)}', style: TextStyle(fontSize: 13, color: pal.subtext, decoration: TextDecoration.lineThrough)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 36),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.orange),
                        const SizedBox(width: 4),
                        Text('${p.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: pal.primarySoft, borderRadius: BorderRadius.circular(8)),
                          child: Text('${p.discountPercent}% OFF', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Product Detail', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(p.description, style: TextStyle(color: pal.subtext, height: 1.6, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
              child: PrimaryButton(
                label: 'Add To Basket',
                icon: Icons.shopping_bag_outlined,
                onPressed: () {
                  state.addToCart(p, qty: _qty);
                  context.snack('Added $_qty × ${p.name}');
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
