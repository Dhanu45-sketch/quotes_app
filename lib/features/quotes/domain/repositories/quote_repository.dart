import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';
import 'package:quotes_app/features/quotes/domain/entities/quotes_page.dart';

abstract interface class QuoteRepository {
  Future<Result<Quote>> getRandomQuote();

  Future<Result<QuotesPage>> getQuotes({required int limit, required int skip});
}
