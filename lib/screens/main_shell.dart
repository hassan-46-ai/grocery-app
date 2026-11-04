import 'package:flutter/material.dart';
import '../core/l10n.dart';
import '../core/app_image.dart';
import '../data/models.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../state/app_state.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = [HomeScreen(), FavoritesScreen(), CartScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final tab = context.select<AppState, int>((s) => s.tab);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: Tween(begin: 0.97, end: 1.0).animate(anim), child: child),
        ),
        child: KeyedSubtree(key: ValueKey(tab), child: _pages[tab]),
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final pal = context.pal;
    final cartCount = s.cartCount;

    Widget item(int i, IconData icon, IconData active, {int badge = 0}) {
      final selected = s.tab == i;
      Widget ic = Icon(selected ? active : icon, size: 26, color: selected ? AppColors.primary : pal.subtext);
      if (badge > 0) ic = Badge(label: Text('$badge'), backgroundColor: AppColors.primary, child: ic);
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => s.setTab(i),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: selected ? 30 : 0,
                height: 3,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 12),
              AnimatedScale(
                scale: selected ? 1.15 : 1,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: ic,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: pal.card,
        boxShadow: [BoxShadow(color: pal.shadow, blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              item(0, Icons.home_outlined, Icons.home_rounded),
              item(1, Icons.favorite_border, Icons.favorite),
              item(2, Icons.shopping_bag_outlined, Icons.shopping_bag, badge: cartCount),
              item(3, Icons.person_outline, Icons.person),
            ],
          ),
        ),
      ),
    );
  }
}
