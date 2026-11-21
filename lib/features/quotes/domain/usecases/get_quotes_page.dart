import 'package:equatable/equatable.dart';
import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/core/usecase/usecase.dart';
import 'package:quotes_app/features/quotes/domain/entities/quotes_page.dart';
import 'package:quotes_app/features/quotes/domain/repositories/quote_repository.dart';

class PageParams extends Equatable {
  const PageParams({required this.limit, required this.skip});

  final int limit;
  final int skip;

  @override
  List<Object?> get props => [limit, skip];
}

class GetQuotesPage implements UseCase<QuotesPage, PageParams> {
  const GetQuotesPage(this._repository);

  final QuoteRepository _repository;

  @override
  Future<Result<QuotesPage>> call(PageParams params) {
    return _repository.getQuotes(limit: params.limit, skip: params.skip);
  }
}
