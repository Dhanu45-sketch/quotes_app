import 'package:quotes_app/features/quotes/domain/entities/quote.dart';

class QuoteModel extends Quote {
  const QuoteModel({
    required super.id,
    required super.text,
    required super.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) => QuoteModel(
    id: json['id'] as int,
    text: json['quote'] as String,
    author: json['author'] as String,
  );
}