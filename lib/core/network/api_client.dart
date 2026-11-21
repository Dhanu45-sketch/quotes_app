import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quotes_app/core/error/exceptions.dart';

class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final Duration timeout;
  final http.Client _client;

  Future<Map<String, dynamic>> getJson(
      String path, {
        Map<String, String>? queryParameters,
      }) async {
    final uri = Uri.parse(baseUrl).replace(
      path: path,
      queryParameters: queryParameters,
    );

    final http.Response response;
    try {
      response = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(timeout);
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on http.ClientException {
      throw const NetworkException();
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(response.statusCode);
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      // Reported as InvalidResponseException below.
    }
    throw const InvalidResponseException();
  }

  void dispose() => _client.close();
}