import 'package:easy_book/const/assets.gen.dart';
import 'package:easy_book/l10n/translate_extension.dart';
import 'package:easy_book/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class InitErrorScreen extends StatelessWidget {
  const InitErrorScreen({
    super.key,
    required this.error,
  });

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              Assets.animations.error,
              height: 400,
              width: 400,
            ),
            const SizedBox(height: 20),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.init.path),
              child: Text(context.l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
