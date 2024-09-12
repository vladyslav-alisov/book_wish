import 'package:easy_book/const/assets.gen.dart';
import 'package:easy_book/l10n/translate_extension.dart';
import 'package:easy_book/providers/app_provider.dart';
import 'package:easy_book/view/home/home_screen.dart';
import 'package:easy_book/view/init/init_error_screen.dart';
import 'package:easy_book/view/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  AppProvider get _appProvider => context.read<AppProvider>();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    try {
      if (_appProvider.isFirstLaunch) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InitErrorScreen(error: e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              Assets.animations.initLoading,
              height: 400,
              width: 400,
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.loadingYourData,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
