import 'package:easy_book/l10n/translate_extension.dart';
import 'package:easy_book/models/app_config/app_config.dart';
import 'package:easy_book/models/app_info/app_info.dart';
import 'package:easy_book/providers/app_provider.dart';
import 'package:easy_book/providers/book_provider.dart';
import 'package:easy_book/providers/search_provider.dart';
import 'package:easy_book/repositories/app_repository.dart';
import 'package:easy_book/repositories/book_repository.dart';
import 'package:easy_book/view/init/init_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  App({
    super.key,
    required this.initConfig,
    required this.appInfo,
    required this.appRepository,
  });

  final AppConfig initConfig;
  final AppInfo appInfo;
  final AppRepository appRepository;

  final BookRepository _bookRepository = BookRepository();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
          create: (_) => AppProvider(
            initConfig,
            appInfo,
            appRepository,
          ),
        ),
        ChangeNotifierProvider<BookProvider>(
          create: (_) => BookProvider(
            _bookRepository,
          ),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(
            _bookRepository,
          ),
        ),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appConfigProvider, child) => MaterialApp(
          locale: appConfigProvider.appLocale,
          theme: FlexThemeData.light(scheme: FlexScheme.indigo),
          darkTheme: FlexThemeData.dark(scheme: FlexScheme.bigStone),
          themeMode: appConfigProvider.themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: supportedLocale,
          home: const InitScreen(),
        ),
      ),
    );
  }
}
