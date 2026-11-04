import 'package:flutter/material.dart';
import '../core/l10n.dart';
import '../core/app_image.dart';
import '../data/models.dart';
import '../widgets/language_widgets.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'info_screen.dart';
import 'login_screen.dart';
import 'orders_screen.dart';
import 'payment_method_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final u = s.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = <Widget>[
      _Item(Icons.edit_outlined, 'Edit Profile', onTap: () => context.push(const EditProfileScreen())),
      _Item(Icons.lock_outline, 'Change Password', onTap: () => context.push(const ChangePasswordScreen())),
      _Item(Icons.credit_card_outlined, 'Payment Method', onTap: () => context.push(const PaymentMethodScreen())),
      _Item(Icons.inventory_2_outlined, 'My Orders', onTap: () => context.push(const OrdersScreen())),
      _Item(
        Icons.language,
        'Language',
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(context.isAr ? 'العربية' : 'English', style: TextStyle(color: context.pal.subtext, fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 22),
        ]),
        onTap: () => showLanguageSheet(context),
      ),
      _Item(
        Icons.dark_mode_outlined,
        'Dark Mode',
        trailing: Switch(value: isDark, onChanged: (v) => s.setThemeMode(v ? ThemeMode.dark : ThemeMode.light)),
        onTap: () => s.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
      ),
      _Item(Icons.shield_outlined, 'Privacy Policy',
          onTap: () => context.push(const InfoScreen(title: 'Privacy Policy', text: 'We respect your privacy. Your personal data is only used to process your orders and improve your shopping experience. We never sell your information to third parties.\n\nReplace this text with your real privacy policy.'))),
      _Item(Icons.description_outlined, 'Terms & Conditions',
          onTap: () => context.push(const InfoScreen(title: 'Terms & Conditions', text: 'By using this app you agree to our terms of service, including accurate order information, payment on delivery or via the selected method, and our delivery and refund policies.\n\nReplace this text with your real terms.'))),
    ];

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 14, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(36), bottomEnd: Radius.circular(14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Tr('My Profile', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(onTap: () => context.push(const EditProfileScreen()), child: AvatarBadge(emoji: u.avatar, size: 62)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                          Text(u.email.isEmpty ? u.phone : u.email, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              children: [for (var i = 0; i < items.length; i++) Reveal(index: i, offset: const Offset(0.1, 0), child: items[i])],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: PrimaryButton(
              label: 'Logout',
              icon: Icons.logout,
              onPressed: () {
                s.logout();
                context.pushReplacementAll(const LoginScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Emoji avatar with the small green edit badge.
class AvatarBadge extends StatelessWidget {
  const AvatarBadge({super.key, required this.emoji, this.size = 62});
  final String emoji;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'avatar',
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: size + 6,
          height: size + 6,
          child: Stack(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(color: context.pal.tile, shape: BoxShape.circle),
                child: Center(child: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: Text(emoji, key: ValueKey(emoji), style: TextStyle(fontSize: size * 0.55)))),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: const Icon(Icons.edit, color: Colors.white, size: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.icon, this.title, {this.onTap, this.trailing});
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TapScale(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Icon(icon, size: 22),
                const SizedBox(width: 14),
                Expanded(child: Tr(title, style: const TextStyle(fontSize: 13.5))),
                trailing ?? const Icon(Icons.chevron_right, size: 22),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
