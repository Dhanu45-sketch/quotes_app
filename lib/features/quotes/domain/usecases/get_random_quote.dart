import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/core/usecase/usecase.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';
import 'package:quotes_app/features/quotes/domain/repositories/quote_repository.dart';

class GetRandomQuote implements UseCase<Quote, NoParams> {
  const GetRandomQuote(this._repository);

  final QuoteRepository _repository;

  @override
  Future<Result<Quote>> call(NoParams params) => _repository.getRandomQuote();
}