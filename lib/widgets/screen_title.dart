import 'package:flutter/material.dart';
import 'package:quotes_app/theme/app_theme.dart';

/// Grey title at the top of the Home and Quotes screens.
class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kScreenPadding, 24, kScreenPadding, 0),
      child: Semantics(
        header: true,
        child: Text(title, style: AppTextStyles.screenTitle),
      ),
    );
  }
}
