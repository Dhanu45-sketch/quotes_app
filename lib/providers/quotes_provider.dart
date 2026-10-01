import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/services/quote_service.dart';

/// State for the Quotes list, with infinite scroll.
class QuotesProvider extends ChangeNotifier {
  QuotesProvider(this._service, {this.pageSize = QuoteService.pageSize});

  final QuoteService _service;
  final int pageSize;

  final List<Quote> _quotes = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  String? _errorMessage;
  String? _loadMoreError;
  bool _disposed = false;

  UnmodifiableListView<Quote> get quotes => UnmodifiableListView(_quotes);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  String? get loadMoreError => _loadMoreError;

  /// Loads the first page + Used by the full-screen retry button.
  Future<void> loadInitial() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    _loadMoreError = null;
    _notify();

    try {
      final page = await _service.getQuotes(limit: pageSize, skip: 0);
      _quotes
        ..clear()
        ..addAll(page.quotes);
      _hasMore = page.hasMore;
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore || _loadMoreError != null) {
      return;
    }
    _isLoadingMore = true;
    _notify();

    try {
      final page = await _service.getQuotes(
        limit: pageSize,
        skip: _quotes.length,
      );
      _quotes.addAll(page.quotes);
      _hasMore = page.hasMore && page.quotes.isNotEmpty;
    } on ApiException catch (error) {
      _loadMoreError = error.message;
    } catch (_) {
      _loadMoreError = 'Something went wrong. Please try again.';
    } finally {
      _isLoadingMore = false;
      _notify();
    }
  }

  Future<void> retryLoadMore() {
    _loadMoreError = null;
    return loadMore();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
