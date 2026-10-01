import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/providers/quotes_provider.dart';
import 'package:quotes_app/screens/quote_detail_screen.dart';
import 'package:quotes_app/widgets/error_view.dart';
import 'package:quotes_app/widgets/quote_card.dart';
import 'package:quotes_app/widgets/screen_title.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<QuotesProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuotesProvider>();

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenTitle('Quotes'),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(QuotesProvider provider) {
    final quotes = provider.quotes;

    if (quotes.isEmpty) {
      final error = provider.errorMessage;
      if (error != null) {
        return ErrorView(message: error, onRetry: provider.loadInitial);
      }
      if (provider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const Center(child: Text('No quotes found.'));
    }

    final hasFooter = provider.isLoadingMore || provider.loadMoreError != null;

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
      itemCount: quotes.length + (hasFooter ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        if (index == quotes.length) return _buildFooter(provider);

        final quote = quotes[index];
        return QuoteCard(
          quote: quote,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => QuoteDetailScreen(quote: quote),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(QuotesProvider provider) {
    if (provider.loadMoreError != null) {
      return Center(
        child: TextButton(
          onPressed: provider.retryLoadMore,
          child: const Text('Couldn’t load more quotes. Tap to retry.'),
        ),
      );
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
