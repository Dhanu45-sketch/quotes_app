import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quotes_app/core/error/failures.dart';
import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';
import 'package:quotes_app/features/quotes/domain/entities/quotes_page.dart';
import 'package:quotes_app/features/quotes/domain/usecases/get_quotes_page.dart';
import 'package:quotes_app/features/quotes/presentation/bloc/quotes_bloc.dart';

class MockGetQuotesPage extends Mock implements GetQuotesPage {}

void main() {
  const first = Quote(id: 1, text: 'One', author: 'A');
  const second = Quote(id: 2, text: 'Two', author: 'B');
  late MockGetQuotesPage getQuotesPage;

  setUpAll(() => registerFallbackValue(const PageParams(limit: 1, skip: 0)));
  setUp(() => getQuotesPage = MockGetQuotesPage());

  QuotesBloc buildBloc() =>
      QuotesBloc(getQuotesPage: getQuotesPage, pageSize: 1);

  blocTest<QuotesBloc, QuotesState>(
    'loads the first page',
    setUp: () {
      when(() => getQuotesPage(any())).thenAnswer(
            (_) async => const Ok(QuotesPage(quotes: [first], hasMore: true)),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const QuotesStarted()),
    expect: () => const [
      QuotesState(status: QuotesStatus.loading),
      QuotesState(status: QuotesStatus.success, quotes: [first], hasMore: true),
    ],
    verify: (_) {
      verify(() => getQuotesPage(const PageParams(limit: 1, skip: 0)))
          .called(1);
    },
  );

  blocTest<QuotesBloc, QuotesState>(
    'appends the next page and stops when nothing is left',
    setUp: () {
      when(() => getQuotesPage(any())).thenAnswer(
            (_) async => const Ok(QuotesPage(quotes: [second], hasMore: false)),
      );
    },
    build: buildBloc,
    seed: () => const QuotesState(
      status: QuotesStatus.success,
      quotes: [first],
      hasMore: true,
    ),
    act: (bloc) => bloc.add(const QuotesNextPageRequested()),
    expect: () => const [
      QuotesState(
        status: QuotesStatus.success,
        quotes: [first],
        hasMore: true,
        isLoadingMore: true,
      ),
      QuotesState(
        status: QuotesStatus.success,
        quotes: [first, second],
        hasMore: false,
      ),
    ],
    verify: (_) {
      verify(() => getQuotesPage(const PageParams(limit: 1, skip: 1)))
          .called(1);
    },
  );

  blocTest<QuotesBloc, QuotesState>(
    'keeps the list and reports a failed page',
    setUp: () {
      when(() => getQuotesPage(any()))
          .thenAnswer((_) async => const Err<QuotesPage>(NetworkFailure()));
    },
    build: buildBloc,
    seed: () => const QuotesState(
      status: QuotesStatus.success,
      quotes: [first],
      hasMore: true,
    ),
    act: (bloc) => bloc.add(const QuotesNextPageRequested()),
    expect: () => const [
      QuotesState(
        status: QuotesStatus.success,
        quotes: [first],
        hasMore: true,
        isLoadingMore: true,
      ),
      QuotesState(
        status: QuotesStatus.success,
        quotes: [first],
        hasMore: true,
        loadMoreFailure: NetworkFailure(),
      ),
    ],
  );

  blocTest<QuotesBloc, QuotesState>(
    'ignores next-page requests while a failed page waits for a retry',
    build: buildBloc,
    seed: () => const QuotesState(
      status: QuotesStatus.success,
      quotes: [first],
      hasMore: true,
      loadMoreFailure: NetworkFailure(),
    ),
    act: (bloc) => bloc.add(const QuotesNextPageRequested()),
    expect: () => const <QuotesState>[],
    verify: (_) {
      verifyNever(() => getQuotesPage(any()));
    },
  );

  blocTest<QuotesBloc, QuotesState>(
    'retry clears the error and loads the next page',
    setUp: () {
      when(() => getQuotesPage(any())).thenAnswer(
            (_) async => const Ok(QuotesPage(quotes: [second], hasMore: false)),
      );
    },
    build: buildBloc,
    seed: () => const QuotesState(
      status: QuotesStatus.success,
      quotes: [first],
      hasMore: true,
      loadMoreFailure: NetworkFailure(),
    ),
    act: (bloc) => bloc.add(const QuotesNextPageRetried()),
    expect: () => const [
      QuotesState(status: QuotesStatus.success, quotes: [first], hasMore: true),
      QuotesState(
        status: QuotesStatus.success,
        quotes: [first],
        hasMore: true,
        isLoadingMore: true,
      ),
      QuotesState(
        status: QuotesStatus.success,
        quotes: [first, second],
        hasMore: false,
      ),
    ],
  );
}