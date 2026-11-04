import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../data/catalog.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/order_success_dialog.dart';
import 'edit_profile_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const _deliveryOptions = [('Standard · 30-45 min', 3.0), ('Express · 15-20 min', 6.0)];
  static const _promoCode = 'FRESH10';

  int _delivery = 0;
  late int _payment = context.read<AppState>().payment;
  double _discountRate = 0;
  final _promo = TextEditingController();

  @override
  void dispose() {
    _promo.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final ok = _promo.text.trim().toUpperCase() == _promoCode;
    setState(() => _discountRate = ok ? 0.10 : 0);
    context.snack(ok ? '10% discount applied 🎉' : 'Invalid promo code');
  }

  Future<void> _placeOrder(double total) async {
    final s = context.read<AppState>();
    if (s.user.address.trim().isEmpty) {
      context.snack('Please add your delivery address first');
      return;
    }
    final approved = await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _ApproveSheet(total: total, address: s.user.address, payment: paymentMethods[_payment]),
    );
    if (approved != true || !mounted) return;

    s.placeOrder(address: s.user.address, payment: paymentMethods[_payment], total: total);
    await showOrderSuccessDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final subtotal = s.cartTotal;
    final discount = subtotal * _discountRate;
    final fee = _deliveryOptions[_delivery].$2;
    final total = subtotal - discount + fee;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const _Title('Delivery address'),
          _Tile(
            selected: true,
            icon: Icons.location_on_outlined,
            title: s.user.address.isEmpty ? 'No address set' : s.user.address,
            subtitle: s.user.phone.isEmpty ? null : s.user.phone,
            trailing: TextButton(onPressed: () => context.push(const EditProfileScreen()), child: const Text('Change', style: TextStyle(color: AppColors.primary))),
          ),
          const _Title('Delivery method'),
          for (var i = 0; i < _deliveryOptions.length; i++)
            _Tile(
              selected: _delivery == i,
              icon: Icons.delivery_dining_outlined,
              title: _deliveryOptions[i].$1,
              trailing: Text(money(_deliveryOptions[i].$2), style: const TextStyle(fontWeight: FontWeight.w700)),
              onTap: () => setState(() => _delivery = i),
            ),
          const _Title('Payment method'),
          for (var i = 0; i < paymentMethods.length; i++)
            _Tile(
              selected: _payment == i,
              icon: const [Icons.payments_outlined, Icons.credit_card, Icons.account_balance_wallet_outlined][i],
              title: paymentMethods[i],
              onTap: () => setState(() => _payment = i),
            ),
          const _Title('Promo code'),
          Row(
            children: [
              Expanded(child: TextField(controller: _promo, decoration: const InputDecoration(hintText: 'Try FRESH10'))),
              const SizedBox(width: 10),
              SizedBox(
                width: 96,
                child: ElevatedButton(onPressed: _applyPromo, style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)), child: const Text('Apply')),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _Row('Subtotal', money(subtotal)),
          if (_discountRate > 0) _Row('Discount', '-${money(discount)}', color: AppColors.primary),
          _Row('Delivery', money(fee)),
          const Divider(height: 28),
          _Row('Total', money(total), bold: true),
          const SizedBox(height: 22),
          PrimaryButton(label: 'Place Order', onPressed: () => _placeOrder(total)),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 10),
        child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.selected, required this.icon, required this.title, this.subtitle, this.trailing, this.onTap});
  final bool selected;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected ? pal.primarySoft : pal.card,
          border: Border.all(color: selected ? AppColors.primary : pal.border, width: selected ? 1.4 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primary : pal.subtext),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5)),
                  if (subtitle != null) Text(subtitle!, style: TextStyle(color: pal.subtext, fontSize: 12)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false, this.color});
  final String label, value;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: bold ? 18 : 14, fontWeight: bold ? FontWeight.w700 : FontWeight.w400, color: color);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: style),
          const SizedBox(width: 16),
          Flexible(child: Text(value, textAlign: TextAlign.end, style: style)),
        ],
      ),
    );
  }
}

class _ApproveSheet extends StatelessWidget {
  const _ApproveSheet({required this.total, required this.address, required this.payment});
  final double total;
  final String address, payment;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Approve your order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Please review the details before confirming.', style: TextStyle(color: context.pal.subtext, fontSize: 13)),
            const SizedBox(height: 20),
            _Row('Deliver to', address),
            _Row('Payment', payment),
            _Row('Total', money(total), bold: true),
            const SizedBox(height: 22),
            PrimaryButton(label: 'Approve & Place Order', onPressed: () => Navigator.pop(context, true)),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Center(child: Text('Cancel', style: TextStyle(color: context.pal.text))),
            ),
          ],
        ),
      ),
    );
  }
}
