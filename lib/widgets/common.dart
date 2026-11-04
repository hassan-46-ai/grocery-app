import 'package:flutter/material.dart';

import '../core/animations.dart';
import '../core/theme.dart';

/// The green "R" brand mark (two-tone).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) {
    TextStyle style(Color c) => TextStyle(fontSize: size, fontWeight: FontWeight.w900, color: c, height: 1);
    return Stack(
      children: [
        Transform.translate(offset: Offset(-size * 0.05, 0), child: Text('R', style: style(AppColors.primaryDark))),
        Text('R', style: style(AppColors.primary)),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onPressed,
      child: IgnorePointer(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.greenBorder = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool greenBorder;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final greenBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.7)),
    );
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && _hidden,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: widget.icon == null ? null : Icon(widget.icon, color: context.pal.subtext),
        enabledBorder: widget.greenBorder ? greenBorder : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(_hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: context.pal.subtext),
                onPressed: () => setState(() => _hidden = !_hidden),
              )
            : null,
      ),
    );
  }
}

class Validators {
  static String? required(String? v) => (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()) ? null : 'Enter a valid email';
  }

  static String? password(String? v) => (v == null || v.length < 6) ? 'At least 6 characters' : null;

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    return RegExp(r'^[+()\-0-9 ]{8,18}$').hasMatch(v.trim()) ? null : 'Enter a valid phone number';
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(actionLabel!, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
            ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.emoji, required this.title, required this.subtitle});
  final String emoji, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Reveal(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: context.pal.subtext)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined quantity control (cart / detail page).
class QtyControl extends StatelessWidget {
  const QtyControl({super.key, required this.qty, required this.onChanged});
  final int qty;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, VoidCallback onTap, {bool filled = false}) => TapScale(
          onTap: onTap,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: filled ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: filled ? AppColors.primary : context.pal.border),
            ),
            child: Icon(icon, size: 18, color: filled ? Colors.white : context.pal.subtext),
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(Icons.remove, () => onChanged(qty - 1)),
        SizedBox(
          width: 36,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: FadeTransition(opacity: a, child: c)),
              child: Text('$qty', key: ValueKey(qty), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        btn(Icons.add, () => onChanged(qty + 1), filled: true),
      ],
    );
  }
}

class HeartButton extends StatelessWidget {
  const HeartButton({super.key, required this.active, required this.onTap, this.size = 20});
  final bool active;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.elasticOut,
          transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
          child: Icon(
            active ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(active),
            size: size,
            color: active ? AppColors.danger : context.pal.subtext,
          ),
        ),
      ),
    );
  }
}
