import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/theme/app_theme.dart';
import 'package:quotes_app/features/quotes/presentation/bloc/quotes_bloc.dart';
import 'package:quotes_app/features/quotes/presentation/bloc/random_quote_bloc.dart';
import 'package:quotes_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:quotes_app/injection_container.dart';

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RandomQuoteBloc>(
          create: (_) =>
          sl<RandomQuoteBloc>()..add(const RandomQuoteRequested()),
        ),
        BlocProvider<QuotesBloc>(
          create: (_) => sl<QuotesBloc>()..add(const QuotesStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Quotes',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}