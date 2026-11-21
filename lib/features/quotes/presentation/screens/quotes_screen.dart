import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/widgets/error_view.dart';
import 'package:quotes_app/core/widgets/screen_title.dart';
import 'package:quotes_app/features/quotes/presentation/bloc/quotes_bloc.dart';
import 'package:quotes_app/features/quotes/presentation/screens/quote_detail_screen.dart';
import 'package:quotes_app/features/quotes/presentation/widgets/quote_card.dart';

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
      context.read<QuotesBloc>().add(const QuotesNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenTitle('Quotes'),
          Expanded(
            child: BlocBuilder<QuotesBloc, QuotesState>(builder: _buildBody),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, QuotesState state) {
    return switch (state.status) {
      QuotesStatus.initial ||
      QuotesStatus.loading => const Center(child: CircularProgressIndicator()),
      QuotesStatus.failure => ErrorView(
        message:
            state.failure?.message ?? 'Something went wrong. Please try again.',
        onRetry: () => context.read<QuotesBloc>().add(const QuotesStarted()),
      ),
      QuotesStatus.success =>
        state.quotes.isEmpty
            ? const Center(child: Text('No quotes found.'))
            : _buildList(context, state),
    };
  }

  Widget _buildList(BuildContext context, QuotesState state) {
    final quotes = state.quotes;
    final hasFooter = state.isLoadingMore || state.loadMoreFailure != null;

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
      itemCount: quotes.length + (hasFooter ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        if (index == quotes.length) return _buildFooter(context, state);

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

  Widget _buildFooter(BuildContext context, QuotesState state) {
    if (state.loadMoreFailure != null) {
      return Center(
        child: TextButton(
          onPressed: () =>
              context.read<QuotesBloc>().add(const QuotesNextPageRetried()),
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
