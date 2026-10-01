import 'package:flutter/material.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/theme/app_theme.dart';

/// Large quote + author, shared by Home and the detail screen.
class QuoteDisplay extends StatelessWidget {
  const QuoteDisplay({required this.quote, super.key});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('“${quote.text}”', style: AppTextStyles.quoteLarge),
        const SizedBox(height: 12),
        Text('- ${quote.author}', style: AppTextStyles.authorLarge),
      ],
    );
  }
}
