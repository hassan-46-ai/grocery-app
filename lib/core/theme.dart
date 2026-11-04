import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animations.dart';

class AppColors {
  static const primary = Color(0xFF5DBE69);
  static const primaryDark = Color(0xFF3E9E52);
  static const orange = Color(0xFFF8A44C);
  static const danger = Color(0xFFE55353);
}

/// Colors that change between light and dark mode.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.bg,
    required this.card,
    required this.border,
    required this.tile,
    required this.text,
    required this.subtext,
    required this.onboardBg,
    required this.primarySoft,
    required this.shadow,
  });

  final Color bg, card, border, tile, text, subtext, onboardBg, primarySoft, shadow;

  static const light = AppPalette(
    bg: Colors.white,
    card: Colors.white,
    border: Color(0xFFE6E6E6),
    tile: Color(0xFFF3F3F3),
    text: Color(0xFF181725),
    subtext: Color(0xFF8A8A8A),
    onboardBg: Color(0xFFEDF8EE),
    primarySoft: Color(0xFFE8F6EA),
    shadow: Color(0x14000000),
  );

  static const dark = AppPalette(
    bg: Color(0xFF121212),
    card: Color(0xFF1E1E1E),
    border: Color(0xFF343434),
    tile: Color(0xFF2A2A2A),
    text: Color(0xFFF2F2F2),
    subtext: Color(0xFFA2A2A2),
    onboardBg: Color(0xFF14231A),
    primarySoft: Color(0xFF1F3326),
    shadow: Color(0x40000000),
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      bg: l(bg, other.bg),
      card: l(card, other.card),
      border: l(border, other.border),
      tile: l(tile, other.tile),
      text: l(text, other.text),
      subtext: l(subtext, other.subtext),
      onboardBg: l(onboardBg, other.onboardBg),
      primarySoft: l(primarySoft, other.primarySoft),
      shadow: l(shadow, other.shadow),
    );
  }
}

extension PaletteX on BuildContext {
  AppPalette get pal => Theme.of(this).extension<AppPalette>()!;
}

final lightTheme = _build(Brightness.light);
final darkTheme = _build(Brightness.dark);

ThemeData _build(Brightness b) {
  final isDark = b == Brightness.dark;
  final pal = isDark ? AppPalette.dark : AppPalette.light;
  final base = ThemeData(brightness: b, useMaterial3: true);
  final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).apply(bodyColor: pal.text, displayColor: pal.text);

  OutlineInputBorder border(Color c, [double w = 1]) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: c, width: w));

  const transitions = FadeSlideTransitionsBuilder();

  return base.copyWith(
    scaffoldBackgroundColor: pal.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: b)
        .copyWith(primary: AppColors.primary, surface: pal.bg),
    textTheme: textTheme,
    extensions: [pal],
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: transitions,
      TargetPlatform.iOS: transitions,
      TargetPlatform.windows: transitions,
      TargetPlatform.macOS: transitions,
      TargetPlatform.linux: transitions,
    }),
    appBarTheme: AppBarTheme(
      backgroundColor: pal.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: pal.text,
      titleTextStyle: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700, fontSize: 17, color: pal.text),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: pal.card,
      border: border(pal.border),
      enabledBorder: border(pal.border),
      focusedBorder: border(AppColors.primary, 1.4),
      errorBorder: border(AppColors.danger),
      focusedErrorBorder: border(AppColors.danger, 1.4),
      labelStyle: TextStyle(color: pal.subtext, fontSize: 14),
      hintStyle: TextStyle(color: pal.subtext, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: AppColors.primary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: pal.card, surfaceTintColor: Colors.transparent),
    dividerTheme: DividerThemeData(color: pal.border, thickness: 1),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : pal.border),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );
}
