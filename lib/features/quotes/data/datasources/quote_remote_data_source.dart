import 'package:quotes_app/core/constants/api_constants.dart';
import 'package:quotes_app/core/network/api_client.dart';
import 'package:quotes_app/features/quotes/data/models/quote_model.dart';
import 'package:quotes_app/features/quotes/data/models/quotes_page_model.dart';

abstract interface class QuoteRemoteDataSource {
  Future<QuoteModel> fetchRandomQuote();

  Future<QuotesPageModel> fetchQuotes({required int limit, required int skip});
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  const QuoteRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<QuoteModel> fetchRandomQuote() async {
    return QuoteModel.fromJson(await _client.getJson(ApiConstants.randomQuote));
  }

  @override
  Future<QuotesPageModel> fetchQuotes({
    required int limit,
    required int skip,
  }) async {
    final json = await _client.getJson(
      ApiConstants.quotes,
      queryParameters: {'limit': '$limit', 'skip': '$skip'},
    );
    return QuotesPageModel.fromJson(json);
  }
}
