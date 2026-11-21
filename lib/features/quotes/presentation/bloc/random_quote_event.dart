part of 'random_quote_bloc.dart';

sealed class RandomQuoteEvent extends Equatable {
  const RandomQuoteEvent();

  @override
  List<Object?> get props => [];
}

final class RandomQuoteRequested extends RandomQuoteEvent {
  const RandomQuoteRequested();
}
