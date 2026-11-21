part of 'quotes_bloc.dart';

enum QuotesStatus { initial, loading, success, failure }

class QuotesState extends Equatable {
  const QuotesState({
    this.status = QuotesStatus.initial,
    this.quotes = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
    this.failure,
    this.loadMoreFailure,
  });

  final QuotesStatus status;
  final List<Quote> quotes;
  final bool hasMore;
  final bool isLoadingMore;
  final Failure? failure;
  final Failure? loadMoreFailure;

  QuotesState copyWith({
    List<Quote>? quotes,
    bool? hasMore,
    bool? isLoadingMore,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
  }) {
    return QuotesState(
      status: status,
      quotes: quotes ?? this.quotes,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure,
      loadMoreFailure: clearLoadMoreFailure
          ? null
          : (loadMoreFailure ?? this.loadMoreFailure),
    );
  }

  @override
  List<Object?> get props => [
    status,
    quotes,
    hasMore,
    isLoadingMore,
    failure,
    loadMoreFailure,
  ];
}
