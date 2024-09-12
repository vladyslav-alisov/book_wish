import 'package:easy_book/models/book/book.dart';
import 'package:easy_book/router/app_routes.dart';
import 'package:easy_book/view/home/details_screen.dart';
import 'package:easy_book/view/home/home_screen.dart';
import 'package:easy_book/view/init/init_error_screen.dart';
import 'package:easy_book/view/init/init_screen.dart';
import 'package:easy_book/view/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static GoRouter? _goRouter;

  static GoRouter get router => _goRouter == null ? throw Exception("Init router first") : _goRouter!;

  static GlobalKey get navigatorKey => _rootNavigatorKey;

  static GoRouter initRouter() {
    _goRouter ??= GoRouter(
      initialLocation: AppRoutes.init.path,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: AppRoutes.init.path,
          builder: (context, state) => const InitScreen(),
        ),
        GoRoute(
          path: AppRoutes.initError.path,
          builder: (context, state) => InitErrorScreen(error: state.extra as dynamic),
        ),
        GoRoute(
          path: AppRoutes.home.path,
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: AppRoutes.details.name,
              builder: (context, state) => DetailsScreen(
                book: state.extra as Book,
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.settings.path,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
    return _goRouter!;
  }
}
