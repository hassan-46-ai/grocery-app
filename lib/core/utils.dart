import 'package:flutter/material.dart';

const kCurrency = '\$';

String money(double v) =>
    v == v.roundToDouble() ? '$kCurrency${v.toInt()}' : '$kCurrency${v.toStringAsFixed(2)}';

String formatDate(DateTime d) {
  const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final h = d.hour.toString().padLeft(2, '0');
  final min = d.minute.toString().padLeft(2, '0');
  return '${d.day} ${m[d.month - 1]} ${d.year}, $h:$min';
}

extension Nav on BuildContext {
  Future<T?> push<T>(Widget page) => Navigator.push<T>(this, MaterialPageRoute(builder: (_) => page));

  void pushReplacementAll(Widget page) =>
      Navigator.pushAndRemoveUntil(this, MaterialPageRoute(builder: (_) => page), (_) => false);

  void snack(String msg) => ScaffoldMessenger.of(this)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
}
