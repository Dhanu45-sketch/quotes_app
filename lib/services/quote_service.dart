import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quotes_app/models/quote.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => 'ApiException: $message';
}

/// Talks to https://dummyjson.com
class QuoteService {
  QuoteService({http.Client? client}) : _client = client ?? http.Client();

  static const int pageSize = 20;
  static const String _baseUrl = 'https://dummyjson.com';

  final http.Client _client;

  Future<Quote> getRandomQuote() async {
    return Quote.fromJson(await _get('/quotes/random'));
  }

  Future<QuotesPage> getQuotes({required int limit, required int skip}) async {
    final json = await _get('/quotes', {'limit': '$limit', 'skip': '$skip'});
    return QuotesPage.fromJson(json);
  }

  Future<Map<String, dynamic>> _get(
    String path, [
    Map<String, String>? query,
  ]) async {
    final uri = Uri.parse(_baseUrl).replace(path: path, queryParameters: query);

    final http.Response response;
    try {
      response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException(
        'No internet connection. Check your network and try again.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const ApiException('The server had a problem. Please try again.');
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      // Handled by the error below.
    }
    throw const ApiException('We received an unexpected response.');
  }

  void dispose() => _client.close();
}
