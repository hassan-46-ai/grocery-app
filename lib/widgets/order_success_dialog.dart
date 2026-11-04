import 'dart:ui';

import 'package:flutter/material.dart';
import '../core/l10n.dart';
import '../core/app_image.dart';
import '../data/models.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../screens/orders_screen.dart';
import '../state/app_state.dart';
import 'common.dart';

/// Blurred-background "Order Placed Successfully" dialog.
Future<void> showOrderSuccessDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'order-success',
    barrierColor: Colors.black.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (_, __, ___) => const _SuccessCard(),
    transitionBuilder: (_, anim, __, child) {
      final scale = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1 + 7 * anim.value, sigmaY: 1 + 7 * anim.value),
        child: FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: Tween(begin: 0.8, end: 1.0).animate(scale), child: child),
        ),
      );
    },
  );
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard();

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 36),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(color: pal.card, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 900),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(color: pal.primarySoft, shape: BoxShape.circle),
                  child: Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 34),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Reveal(
                index: 2,
                child: Tr('Order Placed\nSuccessfully',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, height: 1.25)),
              ),
              const SizedBox(height: 10),
              Reveal(
                index: 3,
                child: Tr('You have successfully made order', style: TextStyle(fontSize: 12.5, color: pal.subtext)),
              ),
              const SizedBox(height: 22),
              Reveal(
                index: 4,
                child: PrimaryButton(
                  label: 'View Order Status',
                  onPressed: () {
                    final nav = Navigator.of(context);
                    context.read<AppState>().setTab(0);
                    nav.pop();
                    nav.popUntil((r) => r.isFirst);
                    nav.push(MaterialPageRoute(builder: (_) => const OrdersScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
