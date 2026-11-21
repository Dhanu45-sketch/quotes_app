import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quotes_app/core/error/exceptions.dart';
import 'package:quotes_app/core/error/failures.dart';
import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/features/quotes/data/datasources/quote_remote_data_source.dart';
import 'package:quotes_app/features/quotes/data/models/quote_model.dart';
import 'package:quotes_app/features/quotes/data/models/quotes_page_model.dart';
import 'package:quotes_app/features/quotes/data/repositories/quote_repository_impl.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';
import 'package:quotes_app/features/quotes/domain/entities/quotes_page.dart';

class MockQuoteRemoteDataSource extends Mock implements QuoteRemoteDataSource {}

void main() {
  const quote = QuoteModel(id: 1, text: 'Hello', author: 'Author');
  late MockQuoteRemoteDataSource remote;
  late QuoteRepositoryImpl repository;

  setUp(() {
    remote = MockQuoteRemoteDataSource();
    repository = QuoteRepositoryImpl(remote);
  });

  group('success', () {
    test('wraps a random quote in Ok', () async {
      when(() => remote.fetchRandomQuote()).thenAnswer((_) async => quote);

      final result = await repository.getRandomQuote();

      expect(result, isA<Ok<Quote>>().having((ok) => ok.value, 'value', quote));
    });

    test('wraps a page of quotes in Ok', () async {
      const page = QuotesPageModel(quotes: [quote], hasMore: true);
      when(() => remote.fetchQuotes(limit: 20, skip: 0))
          .thenAnswer((_) async => page);

      final result = await repository.getQuotes(limit: 20, skip: 0);

      expect(
        result,
        isA<Ok<QuotesPage>>().having((ok) => ok.value, 'value', page),
      );
    });
  });

  group('failure mapping', () {
    final cases = <(String, Object, Failure)>[
      ('no connection', const NetworkException(), const NetworkFailure()),
      ('timeout', const RequestTimeoutException(), const TimeoutFailure()),
      ('server error', const ServerException(500), const ServerFailure()),
      (
        'invalid response',
        const InvalidResponseException(),
        const InvalidResponseFailure(),
      ),
      ('unknown error', Exception('boom'), const UnexpectedFailure()),
    ];

    for (final (name, error, expected) in cases) {
      test('maps $name to ${expected.runtimeType}', () async {
        when(() => remote.fetchRandomQuote())
            .thenAnswer((_) async => throw error);

        final result = await repository.getRandomQuote();

        expect(
          result,
          isA<Err<Quote>>().having((err) => err.failure, 'failure', expected),
        );
      });
    }

    test(
      'maps a malformed payload (TypeError) to InvalidResponseFailure',
      () async {
        when(() => remote.fetchRandomQuote()).thenAnswer(
          (_) async => QuoteModel.fromJson(const {
            'id': 'not a number',
            'quote': 'q',
            'author': 'a',
          }),
        );

        final result = await repository.getRandomQuote();

        expect(
          result,
          isA<Err<Quote>>().having(
            (err) => err.failure,
            'failure',
            const InvalidResponseFailure(),
          ),
        );
      },
    );

    test('maps failures when loading a page too', () async {
      when(() => remote.fetchQuotes(limit: 20, skip: 0))
          .thenAnswer((_) async => throw const NetworkException());

      final result = await repository.getQuotes(limit: 20, skip: 0);

      expect(
        result,
        isA<Err<QuotesPage>>().having(
          (err) => err.failure,
          'failure',
          const NetworkFailure(),
        ),
      );
    });
  });
}
