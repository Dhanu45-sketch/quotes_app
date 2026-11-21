import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/theme/app_theme.dart';
import 'package:quotes_app/core/widgets/error_view.dart';
import 'package:quotes_app/core/widgets/screen_title.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';
import 'package:quotes_app/features/quotes/presentation/bloc/random_quote_bloc.dart';
import 'package:quotes_app/features/quotes/presentation/widgets/quote_display.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RandomQuoteBloc, RandomQuoteState>(
      listenWhen: (previous, current) =>
      previous.status != RandomQuoteStatus.failure &&
          current.status == RandomQuoteStatus.failure &&
          current.quote != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.failure?.message ?? 'Refresh failed.')),
        );
      },
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenTitle('Quote of the Day'),
            Expanded(
              child: BlocBuilder<RandomQuoteBloc, RandomQuoteState>(
                builder: (context, state) {
                  final quote = state.quote;
                  if (quote == null) return _buildFirstLoad(context, state);
                  return _buildQuote(context, quote);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstLoad(BuildContext context, RandomQuoteState state) {
    if (state.status == RandomQuoteStatus.failure) {
      return ErrorView(
        message: state.failure?.message ?? 'Something went wrong. Please try again.',
        onRetry: () =>
            context.read<RandomQuoteBloc>().add(const RandomQuoteRequested()),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

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

  Future<void> _refresh(BuildContext context) {
    final bloc = context.read<RandomQuoteBloc>()
      ..add(const RandomQuoteRequested());
    return bloc.stream
        .firstWhere((state) => state.status != RandomQuoteStatus.loading);
  }
}