import 'package:flutter/foundation.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/services/quote_service.dart';


/// State for the Home screen.
class QuoteOfTheDayProvider extends ChangeNotifier {
  QuoteOfTheDayProvider(this._service);

  final QuoteService _service;

  Quote? _quote;
  String? _errorMessage;
  bool _isLoading = false;
  bool _disposed = false;

  Quote? get quote => _quote;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  /// Returns `false` if the request failed.
  Future<bool> fetch() async {
    if (_isLoading) return true;
    _isLoading = true;
    _errorMessage = null;
    if (_quote == null) _notify(); // show the spinner only on the first load

    try {
      _quote = await _service.getRandomQuote();
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      _notify();
    }
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
