import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<AppState>().orders;
    final pal = context.pal;

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orders.isEmpty
          ? const EmptyState(emoji: '📦', title: 'No orders yet', subtitle: 'Your placed orders will appear here.')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final o = orders[i];
                return Reveal(
                  index: i,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: pal.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: pal.border),
                    ),
                    child: ExpansionTile(
                      shape: const Border(),
                      collapsedShape: const Border(),
                      title: Text('Order #${o.id}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      subtitle: Text('${formatDate(o.date)} · ${money(o.total)}', style: TextStyle(color: pal.subtext, fontSize: 12)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: pal.primarySoft, borderRadius: BorderRadius.circular(8)),
                        child: const Text('Placed', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 11)),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        for (final item in o.items)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Text(item.product.emoji, style: const TextStyle(fontSize: 26)),
                            title: Text(item.product.name),
                            subtitle: Text('${item.qty} × ${money(item.product.price)}'),
                            trailing: Text(money(item.total), style: const TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        const Divider(),
                        Align(alignment: Alignment.centerLeft, child: Text('Deliver to: ${o.address}', style: const TextStyle(fontSize: 12.5))),
                        const SizedBox(height: 4),
                        Align(alignment: Alignment.centerLeft, child: Text('Payment: ${o.payment}', style: const TextStyle(fontSize: 12.5))),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
