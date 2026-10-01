import 'package:flutter/material.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/theme/app_theme.dart';

/// Grey rounded card in the Quotes list.
class QuoteCard extends StatelessWidget {
  const QuoteCard({required this.quote, required this.onTap, super.key});

  final Quote quote;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);

    return Material(
      color: AppColors.card,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(quote.text, style: AppTextStyles.quoteCard),
              const SizedBox(height: 8),
              Text('- ${quote.author}', style: AppTextStyles.authorCard),
            ],
          ),
        ),
      ),
    );
  }
}
