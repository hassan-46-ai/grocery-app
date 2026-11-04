import 'dart:math' as math;

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
import 'login_screen.dart';

class _PageData {
  final String title, body, emoji;
  final List<String> accents;
  const _PageData(this.title, this.body, this.emoji, this.accents);
}

const _pages = [
  _PageData('Buy Groceries Easily\nwith Us', 'Pick from thousands of fresh products\nand fill your basket in seconds.', '🛍️', ['🥖', '🥛', '🥬', '🍅']),
  _PageData('We Deliver Grocery\nat Your Doorstep', 'Sit back and relax while we bring\nyour order straight to your door.', '🛵', ['📦', '🍎', '🥕', '🧀']),
  _PageData('Fresh Products,\nBest Prices', 'Enjoy daily deals and exclusive offers\non your favourite groceries.', '🥗', ['💚', '🍋', '🥑', '🍞']),
];

const _accentAlign = [Alignment(-0.85, -0.7), Alignment(0.9, -0.35), Alignment(-0.8, 0.55), Alignment(0.85, 0.75)];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final _controller = PageController();
  late final AnimationController _float =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  void _finish() {
    context.read<AppState>().completeOnboarding();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _next() => _isLast
      ? _finish()
      : _controller.nextPage(duration: const Duration(milliseconds: 450), curve: Curves.easeInOutCubic);

  @override
  void dispose() {
    _controller.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final media = MediaQuery.of(context);
    final page = _pages[_index];

    return Scaffold(
      backgroundColor: pal.onboardBg,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => _Illustration(data: _pages[i], index: i, controller: _controller, float: _float),
          ),
          PositionedDirectional(
            top: media.padding.top + 12,
            start: 20,
            child: const LangToggle(),
          ),
          PositionedDirectional(
            top: media.padding.top + 12,
            end: 20,
            child: TapScale(
              onTap: _finish,
              child: Row(
                children: [
                  const Tr('Skip', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                  const SizedBox(width: 6),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 16 + media.padding.bottom,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 36),
                  child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 52),
                  decoration: BoxDecoration(color: pal.card, borderRadius: BorderRadius.circular(28)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 6,
                            width: i == _index ? 18 : 6,
                            decoration: BoxDecoration(
                              color: i == _index ? AppColors.primary : pal.border,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (c, a) => FadeTransition(
                          opacity: a,
                          child: SlideTransition(position: Tween(begin: const Offset(0, 0.15), end: Offset.zero).animate(a), child: c),
                        ),
                        child: Column(
                          key: ValueKey(_index),
                          children: [
                            Tr(page.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, height: 1.3)),
                            const SizedBox(height: 12),
                            Tr(page.body, textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, color: pal.subtext, height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(color: pal.card, shape: BoxShape.circle),
                    child: TapScale(
                      onTap: _next,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(_isLast ? Icons.check : Icons.arrow_forward, key: ValueKey(_isLast), color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({required this.data, required this.index, required this.controller, required this.float});
  final _PageData data;
  final int index;
  final PageController controller;
  final Animation<double> float;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: Listenable.merge([controller, float]),
      builder: (_, __) {
        final page = controller.hasClients && controller.position.haveDimensions ? controller.page ?? index.toDouble() : index.toDouble();
        final delta = page - index;
        final fade = (1 - delta.abs()).clamp(0.0, 1.0);

        return Opacity(
          opacity: fade,
          child: Transform.translate(
            offset: Offset(delta * 80 * (Directionality.of(context) == TextDirection.rtl ? -1 : 1), 0),
            child: Align(
              alignment: const Alignment(0, -0.55),
              child: SizedBox(
                width: 320,
                height: height * 0.45,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.14), shape: BoxShape.circle),
                    ),
                    Transform.translate(
                      offset: Offset(0, math.sin(float.value * 2 * math.pi) * 6),
                      child: EmojiImage(folder: 'onboarding', name: '${index + 1}', emoji: data.emoji, size: 190),
                    ),
                    for (var i = 0; i < data.accents.length; i++)
                      Align(
                        alignment: _accentAlign[i],
                        child: Transform.translate(
                          offset: Offset(0, math.sin((float.value + i * 0.25) * 2 * math.pi) * 9),
                          child: Text(data.accents[i], style: const TextStyle(fontSize: 38)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
