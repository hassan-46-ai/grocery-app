import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_image.dart';
import 'core/l10n.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await AssetCatalog.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(prefs),
      child: const HammadStoresApp(),
    ),
  );
}

class HammadStoresApp extends StatelessWidget {
  const HammadStoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.select<AppState, ThemeMode>((s) => s.themeMode);
    final lang = context.select<AppState, String>((s) => s.lang);
    final ar = lang == 'ar';

    return MaterialApp(
      onGenerateTitle: (c) => c.tr('Hammad Stores'),
      debugShowCheckedModeBanner: false,
      locale: Locale(lang),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: appTheme(Brightness.light, ar),
      darkTheme: appTheme(Brightness.dark, ar),
      themeMode: mode,
      themeAnimationDuration: const Duration(milliseconds: 400),
      themeAnimationCurve: Curves.easeInOut,
      home: const SplashScreen(),
    );
  }
}
