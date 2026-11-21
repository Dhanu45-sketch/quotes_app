import 'package:equatable/equatable.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';

class QuotesPage extends Equatable {
  const QuotesPage({required this.quotes, required this.hasMore});

  final List<Quote> quotes;
  final bool hasMore;

  @override
  List<Object?> get props => [quotes, hasMore];
}