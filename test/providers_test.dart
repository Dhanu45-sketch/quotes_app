import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/providers/quote_of_the_day_provider.dart';
import 'package:quotes_app/providers/quotes_provider.dart';
import 'package:quotes_app/services/quote_service.dart';

class FakeQuoteService implements QuoteService {
  FakeQuoteService({this.total = 45});

  final int total;

  bool failNext = false;
  int randomCalls = 0;
  int pageCalls = 0;

  @override
  Future<Quote> getRandomQuote() async {
    randomCalls++;
    _throwIfFailing();
    return const Quote(id: 1, text: 'Random quote', author: 'Some Author');
  }

  @override
  Future<QuotesPage> getQuotes({required int limit, required int skip}) async {
    pageCalls++;
    _throwIfFailing();
    final end = min(skip + limit, total);
    return QuotesPage(
      quotes: [
        for (var i = skip; i < end; i++)
          Quote(id: i + 1, text: 'Quote ${i + 1}', author: 'Author ${i + 1}'),
      ],
      hasMore: end < total,
    );
  }

  @override
  void dispose() {}

  void _throwIfFailing() {
    if (failNext) {
      failNext = false;
      throw const ApiException('boom');
    }
  }
}

void main() {
  group('QuoteOfTheDayProvider', () {
    late FakeQuoteService service;
    late QuoteOfTheDayProvider provider;

    setUp(() {
      service = FakeQuoteService();
      provider = QuoteOfTheDayProvider(service);
    });

    test('loads a quote', () async {
      final future = provider.fetch();
      expect(provider.isLoading, isTrue);

      expect(await future, isTrue);
      expect(provider.isLoading, isFalse);
      expect(provider.quote?.text, 'Random quote');
    });

    test('first-load failure exposes the error and can be retried', () async {
      service.failNext = true;

      expect(await provider.fetch(), isFalse);
      expect(provider.quote, isNull);
      expect(provider.errorMessage, 'boom');

      expect(await provider.fetch(), isTrue);
      expect(provider.errorMessage, isNull);
      expect(provider.quote, isNotNull);
    });

    test('a failed refresh keeps the current quote', () async {
      await provider.fetch();

      service.failNext = true;
      expect(await provider.fetch(), isFalse);

      expect(provider.quote, isNotNull);
    });

    test('ignores a second fetch while one is running', () async {
      await Future.wait([provider.fetch(), provider.fetch()]);

      expect(service.randomCalls, 1);
    });
  });

  group('QuotesProvider', () {
    late FakeQuoteService service;
    late QuotesProvider provider;

    setUp(() {
      service = FakeQuoteService(total: 45);
      provider = QuotesProvider(service, pageSize: 20);
    });

    test('loadInitial loads the first page', () async {
      await provider.loadInitial();

      expect(provider.quotes, hasLength(20));
      expect(provider.hasMore, isTrue);
      expect(provider.isLoading, isFalse);
    });

    test('loadMore appends pages until the list is exhausted', () async {
      await provider.loadInitial();
      await provider.loadMore();
      expect(provider.quotes, hasLength(40));

      await provider.loadMore();
      expect(provider.quotes, hasLength(45));
      expect(provider.hasMore, isFalse);

      final callsBefore = service.pageCalls;
      await provider.loadMore();
      expect(service.pageCalls, callsBefore);
    });

    test('initial failure exposes the error and retry recovers', () async {
      service.failNext = true;
      await provider.loadInitial();

      expect(provider.quotes, isEmpty);
      expect(provider.errorMessage, 'boom');

      await provider.loadInitial();
      expect(provider.errorMessage, isNull);
      expect(provider.quotes, hasLength(20));
    });

    test('a failed page keeps existing quotes and waits for a retry', () async {
      await provider.loadInitial();

      service.failNext = true;
      await provider.loadMore();
      expect(provider.loadMoreError, 'boom');
      expect(provider.quotes, hasLength(20));

      final callsBefore = service.pageCalls;
      await provider.loadMore();
      expect(service.pageCalls, callsBefore);

      await provider.retryLoadMore();
      expect(provider.loadMoreError, isNull);
      expect(provider.quotes, hasLength(40));
    });
  });
}
