import 'package:quotes_app/features/quotes/data/models/quote_model.dart';
import 'package:quotes_app/features/quotes/domain/entities/quotes_page.dart';

class QuotesPageModel extends QuotesPage {
  const QuotesPageModel({required super.quotes, required super.hasMore});

  factory QuotesPageModel.fromJson(Map<String, dynamic> json) {
    final quotes = (json['quotes'] as List<dynamic>)
        .map((item) => QuoteModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
    final total = json['total'] as int;
    final skip = json['skip'] as int;
    return QuotesPageModel(quotes: quotes, hasMore: skip + quotes.length < total);
  }
}