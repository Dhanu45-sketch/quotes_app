part of 'random_quote_bloc.dart';

enum RandomQuoteStatus { initial, loading, success, failure }

class RandomQuoteState extends Equatable {
  const RandomQuoteState({
    this.status = RandomQuoteStatus.initial,
    this.quote,
    this.failure,
  });

  final RandomQuoteStatus status;
  final Quote? quote;
  final Failure? failure;

  @override
  List<Object?> get props => [status, quote, failure];
}