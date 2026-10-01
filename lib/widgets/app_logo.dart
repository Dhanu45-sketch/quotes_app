import 'package:flutter/material.dart';
import 'package:quotes_app/theme/app_theme.dart';

/// Opening quotation mark. Material's `format_quote` glyph is a closing quote,
/// so it is turned 180 degrees. Colour and size fall back to the surrounding
/// [IconTheme] when not given.
class QuoteMarkIcon extends StatelessWidget {
  const QuoteMarkIcon({this.size, this.color, super.key});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 2,
      child: Icon(Icons.format_quote_rounded, size: size, color: color),
    );
  }
}

/// The app icon: blue rounded tile with a white quote mark. Drawn in code so
/// it stays sharp at any size.
class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 256, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.15),
      ),
      child: QuoteMarkIcon(size: size, color: Colors.white),
    );
  }
}
