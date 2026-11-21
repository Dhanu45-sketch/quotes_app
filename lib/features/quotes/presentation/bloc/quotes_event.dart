part of 'quotes_bloc.dart';

sealed class QuotesEvent extends Equatable {
  const QuotesEvent();

  @override
  List<Object?> get props => [];
}

final class QuotesStarted extends QuotesEvent {
  const QuotesStarted();
}

final class QuotesNextPageRequested extends QuotesEvent {
  const QuotesNextPageRequested();
}

final class QuotesNextPageRetried extends QuotesEvent {
  const QuotesNextPageRetried();
}
