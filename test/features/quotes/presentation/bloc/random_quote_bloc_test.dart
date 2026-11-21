import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quotes_app/core/error/failures.dart';
import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/core/usecase/usecase.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';
import 'package:quotes_app/features/quotes/domain/usecases/get_random_quote.dart';
import 'package:quotes_app/features/quotes/presentation/bloc/random_quote_bloc.dart';

class MockGetRandomQuote extends Mock implements GetRandomQuote {}

void main() {
  const quote = Quote(id: 1, text: 'Hello', author: 'Author');
  late MockGetRandomQuote getRandomQuote;

  setUpAll(() => registerFallbackValue(const NoParams()));
  setUp(() => getRandomQuote = MockGetRandomQuote());

  blocTest<RandomQuoteBloc, RandomQuoteState>(
    'emits loading, then success when the quote loads',
    setUp: () {
      when(() => getRandomQuote(any()))
          .thenAnswer((_) async => const Ok(quote));
    },
    build: () => RandomQuoteBloc(getRandomQuote: getRandomQuote),
    act: (bloc) => bloc.add(const RandomQuoteRequested()),
    expect: () => const [
      RandomQuoteState(status: RandomQuoteStatus.loading),
      RandomQuoteState(status: RandomQuoteStatus.success, quote: quote),
    ],
  );

  blocTest<RandomQuoteBloc, RandomQuoteState>(
    'emits loading, then failure when the request fails',
    setUp: () {
      when(() => getRandomQuote(any()))
          .thenAnswer((_) async => const Err<Quote>(NetworkFailure()));
    },
    build: () => RandomQuoteBloc(getRandomQuote: getRandomQuote),
    act: (bloc) => bloc.add(const RandomQuoteRequested()),
    expect: () => const [
      RandomQuoteState(status: RandomQuoteStatus.loading),
      RandomQuoteState(
        status: RandomQuoteStatus.failure,
        failure: NetworkFailure(),
      ),
    ],
  );

  blocTest<RandomQuoteBloc, RandomQuoteState>(
    'keeps the current quote when a refresh fails',
    setUp: () {
      when(() => getRandomQuote(any()))
          .thenAnswer((_) async => const Err<Quote>(NetworkFailure()));
    },
    build: () => RandomQuoteBloc(getRandomQuote: getRandomQuote),
    seed: () => const RandomQuoteState(
      status: RandomQuoteStatus.success,
      quote: quote,
    ),
    act: (bloc) => bloc.add(const RandomQuoteRequested()),
    expect: () => const [
      RandomQuoteState(status: RandomQuoteStatus.loading, quote: quote),
      RandomQuoteState(
        status: RandomQuoteStatus.failure,
        quote: quote,
        failure: NetworkFailure(),
      ),
    ],
  );
}