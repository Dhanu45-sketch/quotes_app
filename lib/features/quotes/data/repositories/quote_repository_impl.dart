import 'package:quotes_app/core/error/exceptions.dart';
import 'package:quotes_app/core/error/failures.dart';
import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/features/quotes/data/datasources/quote_remote_data_source.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';
import 'package:quotes_app/features/quotes/domain/entities/quotes_page.dart';
import 'package:quotes_app/features/quotes/domain/repositories/quote_repository.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  const QuoteRepositoryImpl(this._remote);

  final QuoteRemoteDataSource _remote;

  @override
  Future<Result<Quote>> getRandomQuote() {
    return _guard<Quote>(_remote.fetchRandomQuote);
  }

  @override
  Future<Result<QuotesPage>> getQuotes({
    required int limit,
    required int skip,
  }) {
    return _guard<QuotesPage>(
          () => _remote.fetchQuotes(limit: limit, skip: skip),
    );
  }

  Future<Result<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Ok(await request());
    } catch (error) {
      return Err(_toFailure(error));
    }
  }

  Failure _toFailure(Object error) => switch (error) {
    NetworkException() => const NetworkFailure(),
    RequestTimeoutException() => const TimeoutFailure(),
    ServerException() => const ServerFailure(),
    InvalidResponseException() || TypeError() => const InvalidResponseFailure(),
    _ => const UnexpectedFailure(),
  };
}