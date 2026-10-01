import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/providers/quote_of_the_day_provider.dart';
import 'package:quotes_app/providers/quotes_provider.dart';
import 'package:quotes_app/screens/splash_screen.dart';
import 'package:quotes_app/services/quote_service.dart';
import 'package:quotes_app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.navBar,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        Provider<QuoteService>(
          create: (_) => QuoteService(),
          dispose: (_, service) => service.dispose(),
        ),
        ChangeNotifierProvider<QuoteOfTheDayProvider>(
          create: (context) =>
              QuoteOfTheDayProvider(context.read<QuoteService>())..fetch(),
        ),
        ChangeNotifierProvider<QuotesProvider>(
          create: (context) =>
              QuotesProvider(context.read<QuoteService>())..loadInitial(),
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
