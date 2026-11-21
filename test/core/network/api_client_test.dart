import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:quotes_app/core/error/exceptions.dart';
import 'package:quotes_app/core/network/api_client.dart';

ApiClient clientFor(
  Future<http.Response> Function(http.Request request) handler, {
  Duration timeout = const Duration(seconds: 1),
}) {
  return ApiClient(
    baseUrl: 'https://example.com',
    client: MockClient(handler),
    timeout: timeout,
  );
}

void main() {
  test('returns the decoded JSON and builds the request URL', () async {
    late Uri requested;
    final client = clientFor((request) async {
      requested = request.url;
      return http.Response('{"id": 1}', 200);
    });

    final json = await client.getJson(
      '/quotes',
      queryParameters: {'limit': '20', 'skip': '0'},
    );

    expect(json, {'id': 1});
    expect(requested.toString(), 'https://example.com/quotes?limit=20&skip=0');
  });

  test('throws ServerException for a non-2xx status', () async {
    final client = clientFor((_) async => http.Response('oops', 500));

    await expectLater(
      client.getJson('/x'),
      throwsA(
        isA<ServerException>().having((e) => e.statusCode, 'statusCode', 500),
      ),
    );
  });

  test('throws InvalidResponseException for a body that is not JSON', () async {
    final client = clientFor((_) async => http.Response('not json', 200));

    await expectLater(
      client.getJson('/x'),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test(
    'throws InvalidResponseException when the JSON is not an object',
    () async {
      final client = clientFor((_) async => http.Response('[1, 2]', 200));

      await expectLater(
        client.getJson('/x'),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );

  test('throws NetworkException when the connection fails', () async {
    final client = clientFor(
      (_) async => throw http.ClientException('offline'),
    );

    await expectLater(client.getJson('/x'), throwsA(isA<NetworkException>()));
  });

  test('throws RequestTimeoutException when the server is too slow', () async {
    final client = clientFor(
      (_) => Completer<http.Response>().future,
      timeout: const Duration(milliseconds: 10),
    );

    await expectLater(
      client.getJson('/x'),
      throwsA(isA<RequestTimeoutException>()),
    );
  });
}
