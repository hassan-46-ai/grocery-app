import 'package:flutter/material.dart';

import 'l10n.dart';

String _fmt(double v) {
  final fixed = v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return parts.length > 1 ? '$whole.${parts[1]}' : whole;
}

/// Egyptian pounds: "EGP 1,250" (English) / "1,250 ج.م" (Arabic).
String money(BuildContext c, double v) => c.isAr ? '${_fmt(v)} ج.م' : 'EGP ${_fmt(v)}';

String formatDate(BuildContext c, DateTime d) {
  const en = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  const ar = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
  final h = d.hour.toString().padLeft(2, '0');
  final min = d.minute.toString().padLeft(2, '0');
  final month = (c.isAr ? ar : en)[d.month - 1];
  return '${d.day} $month ${d.year}, $h:$min';
}

extension Nav on BuildContext {
  Future<T?> push<T>(Widget page) => Navigator.push<T>(this, MaterialPageRoute(builder: (_) => page));

  void pushReplacementAll(Widget page) =>
      Navigator.pushAndRemoveUntil(this, MaterialPageRoute(builder: (_) => page), (_) => false);

  void snack(String msg) => ScaffoldMessenger.of(this)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(tr(msg)),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
}
