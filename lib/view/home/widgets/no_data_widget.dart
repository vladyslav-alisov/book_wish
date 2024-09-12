import 'package:easy_book/const/assets.gen.dart';
import 'package:easy_book/l10n/translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
    this.widget,
  });

  final String? widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LottieBuilder.asset(
          Assets.animations.noData,
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            widget ?? context.l10n.sorryWeCouldNotFindResultsForYourSearch,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
