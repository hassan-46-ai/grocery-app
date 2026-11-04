import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../data/catalog.dart';
import '../state/app_state.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final pal = context.pal;
    const icons = [Icons.payments_outlined, Icons.credit_card, Icons.account_balance_wallet_outlined];

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Method')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (var i = 0; i < paymentMethods.length; i++)
            Reveal(
              index: i,
              child: GestureDetector(
                onTap: () => s.setPayment(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: s.payment == i ? pal.primarySoft : pal.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: s.payment == i ? AppColors.primary : pal.border, width: s.payment == i ? 1.4 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(icons[i], color: s.payment == i ? AppColors.primary : pal.subtext),
                      const SizedBox(width: 14),
                      Expanded(child: Text(paymentMethods[i], style: const TextStyle(fontWeight: FontWeight.w500))),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: s.payment == i ? 1 : 0,
                        child: const Icon(Icons.check_circle, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
