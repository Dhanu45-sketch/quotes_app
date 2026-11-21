import 'package:get_it/get_it.dart';
import 'package:quotes_app/core/constants/api_constants.dart';
import 'package:quotes_app/core/network/api_client.dart';
import 'package:quotes_app/features/quotes/data/datasources/quote_remote_data_source.dart';
import 'package:quotes_app/features/quotes/data/repositories/quote_repository_impl.dart';
import 'package:quotes_app/features/quotes/domain/repositories/quote_repository.dart';
import 'package:quotes_app/features/quotes/domain/usecases/get_quotes_page.dart';
import 'package:quotes_app/features/quotes/domain/usecases/get_random_quote.dart';
import 'package:quotes_app/features/quotes/presentation/bloc/quotes_bloc.dart';
import 'package:quotes_app/features/quotes/presentation/bloc/random_quote_bloc.dart';

final GetIt sl = GetIt.instance;

void configureDependencies() {
  sl
    ..registerLazySingleton<ApiClient>(
          () => ApiClient(baseUrl: ApiConstants.baseUrl),
      dispose: (client) => client.dispose(),
    )
    ..registerLazySingleton<QuoteRemoteDataSource>(
          () => QuoteRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<QuoteRepository>(() => QuoteRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetRandomQuote(sl()))
    ..registerLazySingleton(() => GetQuotesPage(sl()))
    ..registerFactory(() => RandomQuoteBloc(getRandomQuote: sl()))
    ..registerFactory(() => QuotesBloc(getQuotesPage: sl()));
}