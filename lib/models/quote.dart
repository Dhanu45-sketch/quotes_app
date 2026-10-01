class Quote {
  const Quote({required this.id, required this.text, required this.author});

  /// The API calls the text field `quote`.
  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json['id'] as int,
        text: json['quote'] as String,
        author: json['author'] as String,
      );

  final int id;
  final String text;
  final String author;
}

/// One page of the paginated `/quotes` endpoint.
class QuotesPage {
  const QuotesPage({required this.quotes, required this.hasMore});

  factory QuotesPage.fromJson(Map<String, dynamic> json) {
    final quotes = (json['quotes'] as List<dynamic>)
        .map((item) => Quote.fromJson(item as Map<String, dynamic>))
        .toList();
    final total = json['total'] as int;
    final skip = json['skip'] as int;
    return QuotesPage(quotes: quotes, hasMore: skip + quotes.length < total);
  }

  final List<Quote> quotes;
  final bool hasMore;
}
