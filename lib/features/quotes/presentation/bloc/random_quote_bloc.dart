import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/error/failures.dart';
import 'package:quotes_app/core/result/result.dart';
import 'package:quotes_app/core/usecase/usecase.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote.dart';
import 'package:quotes_app/features/quotes/domain/usecases/get_random_quote.dart';

part 'random_quote_event.dart';
part 'random_quote_state.dart';

class RandomQuoteBloc extends Bloc<RandomQuoteEvent, RandomQuoteState> {
  RandomQuoteBloc({required this._getRandomQuote})
    : super(const RandomQuoteState()) {
    on<RandomQuoteRequested>(_onRequested, transformer: droppable());
  }
  final GetRandomQuote _getRandomQuote;

  Future<void> _onRequested(
    RandomQuoteRequested event,
    Emitter<RandomQuoteState> emit,
  ) async {
    emit(
      RandomQuoteState(status: RandomQuoteStatus.loading, quote: state.quote),
    );

    final result = await _getRandomQuote(const NoParams());

    switch (result) {
      case Ok(:final value):
        emit(RandomQuoteState(status: RandomQuoteStatus.success, quote: value));
      case Err(:final failure):
        emit(
          RandomQuoteState(
            status: RandomQuoteStatus.failure,
            quote: state.quote,
            failure: failure,
          ),
        );
    }
  }
}
