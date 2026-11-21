import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/features/quotes/data/models/quote_model.dart';
import 'package:quotes_app/features/quotes/data/models/quotes_page_model.dart';

void main() {
  test('QuoteModel maps the API "quote" field to text', () {
    final model = QuoteModel.fromJson(const {
      'id': 1,
      'quote': 'Life is short.',
      'author': 'Someone',
    });

    expect(model.id, 1);
    expect(model.text, 'Life is short.');
    expect(model.author, 'Someone');
  });

  Map<String, dynamic> pageJson({required int total}) => {
    'quotes': [
      {'id': 1, 'quote': 'A', 'author': 'X'},
      {'id': 2, 'quote': 'B', 'author': 'Y'},
    ],
    'total': total,
    'skip': 0,
    'limit': 2,
  };

  test('QuotesPageModel reports hasMore when pages remain', () {
    final page = QuotesPageModel.fromJson(pageJson(total: 100));

    expect(page.quotes, hasLength(2));
    expect(page.hasMore, isTrue);
  });

  test('QuotesPageModel reports no more pages on the last page', () {
    expect(QuotesPageModel.fromJson(pageJson(total: 2)).hasMore, isFalse);
  });
}
