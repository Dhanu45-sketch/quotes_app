import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/models/quote.dart';

void main() {
  test('Quote.fromJson maps the API "quote" field to text', () {
    final quote = Quote.fromJson({
      'id': 1,
      'quote': "Life isn't about getting and having, it's about giving and being.",
      'author': 'Kevin Kruse',
    });

    expect(quote.id, 1);
    expect(quote.text, startsWith("Life isn't about"));
    expect(quote.author, 'Kevin Kruse');
  });

  test('QuotesPage.fromJson works out whether more pages remain', () {
    final json = {
      'quotes': [
        {'id': 1, 'quote': 'A', 'author': 'X'},
        {'id': 2, 'quote': 'B', 'author': 'Y'},
      ],
      'total': 100,
      'skip': 0,
      'limit': 2,
    };

    expect(QuotesPage.fromJson(json).hasMore, isTrue);
    expect(QuotesPage.fromJson({...json, 'total': 2}).hasMore, isFalse);
  });
}
