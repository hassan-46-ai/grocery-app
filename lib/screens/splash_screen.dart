import 'dart:async';

import 'package:flutter/material.dart';
import '../core/l10n.dart';
import '../core/app_image.dart';
import '../data/models.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';

// (emoji, right, bottom, size, delay 0..1)
const _veggies = <(String, double, double, double, double)>[
  ('🥬', 0, 0, 84, 0.00),
  ('🫑', 6, 62, 72, 0.10),
  ('🥦', 92, 8, 64, 0.20),
  ('🍅', 158, 2, 40, 0.30),
  ('🍋', 134, 72, 38, 0.40),
  ('🧄', 196, 44, 38, 0.50),
  ('🍆', 70, 92, 46, 0.35),
  ('🍅', 40, 150, 26, 0.60),
  ('🌿', 190, 112, 28, 0.55),
];

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _c.forward();
    _timer = Timer(const Duration(milliseconds: 3000), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    final s = context.read<AppState>();
    final Widget target = !s.onboardingSeen
        ? const OnboardingScreen()
        : s.loggedIn
            ? const MainShell()
            : const LoginScreen();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => target,
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: CurvedAnimation(parent: a, curve: Curves.easeInOut), child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoAnim = CurvedAnimation(parent: _c, curve: const Interval(0, 0.5, curve: Curves.elasticOut));
    final logoFade = CurvedAnimation(parent: _c, curve: const Interval(0, 0.25, curve: Curves.easeIn));

    return Scaffold(
      backgroundColor: context.pal.bg,
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: logoFade,
              child: ScaleTransition(scale: Tween(begin: 0.5, end: 1.0).animate(logoAnim), child: const AppLogo(size: 96)),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 270,
              height: 250,
              child: AnimatedBuilder(
                animation: _c,
                builder: (_, __) => Stack(
                  children: [
                    for (final (emoji, right, bottom, size, delay) in _veggies)
                      Builder(builder: (_) {
                        final start = 0.2 + delay * 0.45;
                        final t = Curves.easeOutCubic.transform(((_c.value - start) / 0.35).clamp(0.0, 1.0));
                        return Positioned(
                          right: right,
                          bottom: bottom,
                          child: Opacity(
                            opacity: t,
                            child: Transform.translate(
                              offset: Offset((1 - t) * 90, (1 - t) * 90),
                              child: Transform.rotate(angle: (1 - t) * 0.8, child: Text(emoji, style: TextStyle(fontSize: size))),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
