import 'package:flutter/material.dart';
import '../core/l10n.dart';
import '../core/app_image.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../core/utils.dart';
import '../data/catalog.dart';
import '../data/models.dart';
import '../state/app_state.dart';
import 'common.dart';

Future<void> showFilterSheet(BuildContext context) {
  final state = context.read<AppState>();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (_) => _FilterSheet(initial: state.filter, onApply: state.setFilter),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial, required this.onApply});
  final ProductFilter initial;
  final ValueChanged<ProductFilter> onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late ProductFilter f = widget.initial;

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Tr(t, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      );

  @override
  Widget build(BuildContext context) {
    const sortLabels = {
      SortBy.none: 'Default',
      SortBy.priceLow: 'Price: low to high',
      SortBy.priceHigh: 'Price: high to low',
      SortBy.rating: 'Top rated',
    };
    final soft = AppColors.primary.withOpacity(0.22);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Tr('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            _label('Categories'),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final c in categories)
                  FilterChip(
                    label: Text('${c.emoji} ${c.nameIn(context)}', style: const TextStyle(fontSize: 12)),
                    selected: f.categories.contains(c.name),
                    selectedColor: soft,
                    showCheckmark: false,
                    onSelected: (on) {
                      final set = {...f.categories};
                      on ? set.add(c.name) : set.remove(c.name);
                      setState(() => f = f.copyWith(categories: set));
                    },
                  ),
              ],
            ),
            _label(context.tr('Max price: {p}', {'p': money(context, f.maxPrice)})),
            Slider(
              value: f.maxPrice,
              min: 10,
              max: ProductFilter.maxPriceLimit,
              divisions: 39,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => f = f.copyWith(maxPrice: v)),
            ),
            _label('Minimum rating'),
            Wrap(
              spacing: 8,
              children: [
                for (final r in [0.0, 4.0, 4.3, 4.6])
                  ChoiceChip(
                    label: Text(r == 0 ? context.tr('Any') : '$r ★+'),
                    selected: f.minRating == r,
                    selectedColor: soft,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => f = f.copyWith(minRating: r)),
                  ),
              ],
            ),
            _label('Sort by'),
            Wrap(
              spacing: 8,
              children: [
                for (final e in sortLabels.entries)
                  ChoiceChip(
                    label: Tr(e.value),
                    selected: f.sort == e.key,
                    selectedColor: soft,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => f = f.copyWith(sort: e.key)),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      side: BorderSide(color: context.pal.border),
                      foregroundColor: context.pal.text,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => setState(() => f = const ProductFilter()),
                    child: const Tr('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: 'Apply Filter',
                    onPressed: () {
                      widget.onApply(f);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
