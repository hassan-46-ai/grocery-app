import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../data/catalog.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/product_widgets.dart';
import 'categories_screen.dart';
import 'edit_profile_screen.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: 18),
            const _SearchRow(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              transitionBuilder: (c, a) => FadeTransition(opacity: a, child: c),
              child: s.isSearching ? const _Results(key: ValueKey('results')) : const _Browse(key: ValueKey('browse')),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final pal = context.pal;

    return Row(
      children: [
        const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 26),
        const SizedBox(width: 8),
        Expanded(
          child: TapScale(
            onTap: () => context.push(const EditProfileScreen()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Text('Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Icon(Icons.keyboard_arrow_down, size: 20),
                ]),
                Text(
                  s.user.address.isEmpty ? 'Tap to add your address' : s.user.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.5, color: pal.subtext),
                ),
              ],
            ),
          ),
        ),
        TapScale(
          onTap: () => s.setTab(2),
          child: Badge(
            isLabelVisible: s.cartCount > 0,
            label: Text('${s.cartCount}'),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.shopping_bag_outlined, size: 26),
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}

class _SearchRow extends StatefulWidget {
  const _SearchRow();

  @override
  State<_SearchRow> createState() => _SearchRowState();
}

class _SearchRowState extends State<_SearchRow> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final pal = context.pal;
    if (_controller.text != state.query) _controller.text = state.query;
    const none = OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide.none);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: state.setQuery,
            decoration: InputDecoration(
              hintText: 'Search',
              filled: true,
              fillColor: pal.tile,
              border: none,
              enabledBorder: none,
              focusedBorder: none,
              prefixIcon: Icon(Icons.search, color: pal.subtext),
            ),
          ),
        ),
        const SizedBox(width: 10),
        TapScale(
          onTap: () => showFilterSheet(context),
          child: Badge(
            isLabelVisible: state.filter.isActive,
            smallSize: 10,
            backgroundColor: AppColors.orange,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.tune, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final results = s.filteredProducts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Results (${results.length})', actionLabel: 'Clear', onAction: s.clearSearch),
        if (results.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: EmptyState(emoji: '🔍', title: 'No products found', subtitle: 'Try changing your search or filters.'),
          )
        else
          ProductGrid(products: results),
      ],
    );
  }
}

class _Browse extends StatelessWidget {
  const _Browse({super.key});

  @override
  Widget build(BuildContext context) {
    final deals = context.read<AppState>().bestDeals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Shop By Category', actionLabel: 'See All', onAction: () => context.push(const CategoriesScreen())),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (_, i) => Reveal(index: i, child: CategoryTile(category: categories[i])),
        ),
        const SizedBox(height: 18),
        const Reveal(index: 3, child: _PromoBanner()),
        SectionHeader(
          title: 'Best Deal',
          actionLabel: 'See All',
          onAction: () => context.push(ProductListScreen(title: 'Best Deal', products: List.from(deals))),
        ),
        HorizontalProducts(products: List.from(deals)),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(color: context.pal.primarySoft, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('World Food Festival,\nBring the world to\nyour Kitchen!',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, height: 1.3)),
                const SizedBox(height: 14),
                SizedBox(
                  width: 110,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () => context.push(const CategoriesScreen()),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(110, 38), textStyle: const TextStyle(fontSize: 12.5)),
                    child: const Text('Shop Now'),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 4,
            child: SizedBox(
              height: 92,
              child: Stack(
                children: [
                  Positioned(right: 0, top: 0, child: Text('🥤', style: TextStyle(fontSize: 70))),
                  Positioned(left: 0, bottom: 0, child: Text('🍪', style: TextStyle(fontSize: 46))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
