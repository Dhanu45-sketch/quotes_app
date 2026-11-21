import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotes_app/app.dart';
import 'package:quotes_app/core/theme/app_theme.dart';
import 'package:quotes_app/injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
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
