
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_image.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _c.forward();

    _timer = Timer(
      const Duration(milliseconds: 3000),
      _goNext,
    );
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
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
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
    final scheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final logoAnim = CurvedAnimation(
      parent: _c,
      curve: const Interval(
        0,
        0.5,
        curve: Curves.elasticOut,
      ),
    );

    final logoFade = CurvedAnimation(
      parent: _c,
      curve: const Interval(
        0,
        0.25,
        curve: Curves.easeIn,
      ),
    );

    return Scaffold(
      backgroundColor: context.pal.bg,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.pal.bg,
              scheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Soft background glow
            Center(
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primary.withOpacity(0.07),
                ),
              ),
            ),

            // App logo
            Center(
              child: FadeTransition(
                opacity: logoFade,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.5,
                    end: 1.0,
                  ).animate(logoAnim),
                  child:  AppLogo(size: 96),
                ),
              ),
            ),

            // Road
            Positioned(
              left: 0,
              right: 0,
              bottom: 55,
              child: Column(
                children: [
                  Container(
                    height: 2,
                    color: scheme.outlineVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: List.generate(
                      8,
                          (index) => Expanded(
                        child: Center(
                          child: Container(
                            width: 20,
                            height: 3,
                            decoration: BoxDecoration(
                              color: scheme.outlineVariant.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Delivery bike moving from left to right
            AnimatedBuilder(
              animation: _c,
              child: Icon(
                Icons.delivery_dining,
                size: 86,
                color: scheme.primary,
              ),
              builder: (context, child) {
                final progress = Curves.easeInOutCubic.transform(
                  ((_c.value - 0.08) / 1.5).clamp(0.0, 2.0),
                );

                final left = -100 + (screenWidth + 200) * progress;

                return Positioned(
                  left: left,
                  bottom: 58,
                  child: Transform.scale(
                    scaleX: 1,
                    child: child,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
