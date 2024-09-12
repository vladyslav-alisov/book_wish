import 'package:easy_book/const/assets.gen.dart';
import 'package:easy_book/providers/app_provider.dart';
import 'package:easy_book/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late final PageController _progressController;
  late final TabController _tabController;
  int currentPage = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _progressController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int index = currentPage + 1;
          if (index <= 2) {
            _progressController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          } else {
            context.read<AppProvider>().saveFirstLaunchConfig(false);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        },
        child: const Icon(Icons.arrow_forward_outlined),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: PageView(
              onPageChanged: (value) {
                currentPage = value;
                _tabController.animateTo(value);
              },
              controller: _progressController,
              children: [
                OnboardingWidget(
                  animationPath: Assets.animations.onBoarding1,
                  text:
                      "Books offer countless benefits, enriching both the mind and the soul. They open the door to new perspectives, helping readers explore different cultures, ideas, and experiences.",
                ),
                OnboardingWidget(
                  animationPath: Assets.animations.onBoarding2,
                  text:
                      "Reading regularly enhances cognitive skills, improving memory, focus, and critical thinking. It also reduces stress, providing a mental escape and a calming effect.",
                ),
                OnboardingWidget(
                  animationPath: Assets.animations.onBoarding3,
                  text:
                      "Books promote creativity and empathy by immersing readers in fictional worlds or real-life stories. They inspire personal growth and lifelong learning, encouraging curiosity and self-reflection.",
                ),
              ],
            ),
          ),
          Expanded(
            child: TabPageSelector(
              controller: _tabController,
            ),
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.1,
          // )
        ],
      ),
    );
  }
}

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({super.key, required String animationPath, required String text})
      : _animationPath = animationPath,
        _text = text;

  final String _animationPath;
  final String _text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 1.4,
          child: Lottie.asset(_animationPath),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Text(
            _text,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
