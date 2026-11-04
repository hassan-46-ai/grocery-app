import 'package:flutter/material.dart';
import '../core/l10n.dart';
import '../core/app_image.dart';
import '../data/models.dart';

import '../core/animations.dart';
import '../core/theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key, required this.title, required this.text});
  final String title, text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Tr(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Reveal(child: Tr(text, style: TextStyle(height: 1.7, fontSize: 13.5, color: context.pal.subtext))),
      ),
    );
  }
}
