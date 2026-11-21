import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/api_constants.dart';
import 'package:quotes_app/core/error/failures.dart';
import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';
import 'package:quotes_app/features/quotes/domain/usecases/get_quotes_page.dart';

part 'quotes_event.dart';
part 'quotes_state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  QuotesBloc({
    required this._getQuotesPage,
    this._pageSize = ApiConstants.pageSize,
  }) : super(const QuotesState()) {
    on<QuotesStarted>(_onStarted, transformer: droppable());
    on<QuotesNextPageRequested>(_onNextPageRequested, transformer: droppable());
    on<QuotesNextPageRetried>(_onNextPageRetried, transformer: droppable());
  }

  final GetQuotesPage _getQuotesPage;
  final int _pageSize;

  Future<void> _onStarted(
      QuotesStarted event,
      Emitter<QuotesState> emit,
      ) async {
    emit(const QuotesState(status: QuotesStatus.loading));

    final result = await _getQuotesPage(PageParams(limit: _pageSize, skip: 0));

    switch (result) {
      case Ok(:final value):
        emit(
          QuotesState(
            status: QuotesStatus.success,
            quotes: value.quotes,
            hasMore: value.hasMore,
          ),
        );
      case Err(:final failure):
        emit(QuotesState(status: QuotesStatus.failure, failure: failure));
    }
  }

  Future<void> _onNextPageRequested(
      QuotesNextPageRequested event,
      Emitter<QuotesState> emit,
      ) {
    return _loadNextPage(emit);
  }

  Future<void> _onNextPageRetried(
      QuotesNextPageRetried event,
      Emitter<QuotesState> emit,
      ) {
    emit(state.copyWith(clearLoadMoreFailure: true));
    return _loadNextPage(emit);
  }

  Future<void> _loadNextPage(Emitter<QuotesState> emit) async {
    if (state.status != QuotesStatus.success ||
        !state.hasMore ||
        state.isLoadingMore ||
        state.loadMoreFailure != null) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getQuotesPage(
      PageParams(limit: _pageSize, skip: state.quotes.length),
    );

    switch (result) {
      case Ok(:final value):
        emit(
          state.copyWith(
            quotes: [...state.quotes, ...value.quotes],
            hasMore: value.hasMore && value.quotes.isNotEmpty,
            isLoadingMore: false,
          ),
        );
      case Err(:final failure):
        emit(state.copyWith(isLoadingMore: false, loadMoreFailure: failure));
    }
  }
}