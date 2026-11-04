import 'package:flutter/material.dart';
import '../core/l10n.dart';
import '../core/app_image.dart';
import '../data/models.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final pal = context.pal;
    final items = s.cartItems;

    return Scaffold(
      appBar: AppBar(title: const Tr('My Cart')),
      body: items.isEmpty
          ? const EmptyState(emoji: '🛒', title: 'Your cart is empty', subtitle: 'Add some fresh groceries to get started.')
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final p = item.product;
                      return Reveal(
                        index: i,
                        child: Dismissible(
                          key: ValueKey(p.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => s.removeFromCart(p.id),
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            alignment: AlignmentDirectional.centerEnd,
                            padding: const EdgeInsetsDirectional.only(end: 22),
                            decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(14)),
                            child: const Icon(Icons.delete_outline, color: Colors.white),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: pal.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: pal.border.withOpacity(0.6)),
                              boxShadow: [BoxShadow(color: pal.shadow, blurRadius: 12, offset: const Offset(0, 4))],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(color: pal.tile, borderRadius: BorderRadius.circular(10)),
                                  child: Center(child: ProductImage(p, size: 56)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.nameIn(context), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                      Text(p.weightIn(context), style: TextStyle(color: pal.subtext, fontSize: 11)),
                                      const SizedBox(height: 8),
                                      QtyControl(qty: item.qty, onChanged: (v) => s.setQty(p.id, v)),
                                    ],
                                  ),
                                ),
                                Text(money(context, item.total), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: TapScale(
                    onTap: () => context.push(const CheckoutScreen()),
                    child: IgnorePointer(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 4),
                            const Tr('Go to Checkout'),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Text(money(context, s.cartTotal), key: ValueKey(s.cartTotal), style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
