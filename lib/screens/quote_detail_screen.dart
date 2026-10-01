import 'package:flutter/material.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/theme/app_theme.dart';
import 'package:quotes_app/widgets/quote_display.dart';

/// "Quote Explore" screen from the design.
class QuoteDetailScreen extends StatelessWidget {
  const QuoteDetailScreen({required this.quote, super.key});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: IconButton(
                tooltip: 'Back',
                icon: const Icon(Icons.arrow_back, size: 28),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
                  child: QuoteDisplay(quote: quote),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
