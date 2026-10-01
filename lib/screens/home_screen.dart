import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/providers/quote_of_the_day_provider.dart';
import 'package:quotes_app/theme/app_theme.dart';
import 'package:quotes_app/widgets/error_view.dart';
import 'package:quotes_app/widgets/quote_display.dart';
import 'package:quotes_app/widgets/screen_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuoteOfTheDayProvider>();
    final quote = provider.quote;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenTitle('Quote of the Day'),
          Expanded(
            child: quote == null
                ? _buildFirstLoad(provider)
                : _buildQuote(context, quote),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstLoad(QuoteOfTheDayProvider provider) {
    final error = provider.errorMessage;
    if (error != null) {
      return ErrorView(message: error, onRetry: provider.fetch);
    }
    return const Center(child: CircularProgressIndicator());
  }

  /// Pull down to fetch another quote.
  Widget _buildQuote(BuildContext context, Quote quote) {
    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
                child: QuoteDisplay(quote: quote),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    final provider = context.read<QuoteOfTheDayProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final succeeded = await provider.fetch();
    if (!succeeded) {
      messenger.showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Refresh failed.')),
      );
    }
  }
}
