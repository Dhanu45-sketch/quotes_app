import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/features/quotes/domain/entities/quotes_page.dart';
import 'package:quotes_app/features/quotes/domain/repositories/quote_repository.dart';
import 'package:quotes_app/features/quotes/domain/usecases/get_quotes_page.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  test('GetQuotesPage forwards its parameters to the repository', () async {
    final repository = MockQuoteRepository();
    const page = QuotesPage(quotes: [], hasMore: false);
    when(() => repository.getQuotes(limit: 5, skip: 10))
        .thenAnswer((_) async => const Ok(page));

    final result = await GetQuotesPage(repository)(
      const PageParams(limit: 5, skip: 10),
    );

    expect(
      result,
      isA<Ok<QuotesPage>>().having((ok) => ok.value, 'value', page),
    );
    verify(() => repository.getQuotes(limit: 5, skip: 10)).called(1);
  });
}
