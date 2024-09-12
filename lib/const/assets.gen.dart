/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// File path: assets/animations/error.json
  String get error => 'assets/animations/error.json';

  /// File path: assets/animations/init_loading.json
  String get initLoading => 'assets/animations/init_loading.json';

  /// File path: assets/animations/loading.json
  String get loading => 'assets/animations/loading.json';

  /// File path: assets/animations/no_data.json
  String get noData => 'assets/animations/no_data.json';

  /// File path: assets/animations/on_boarding_1.json
  String get onBoarding1 => 'assets/animations/on_boarding_1.json';

  /// File path: assets/animations/on_boarding_2.json
  String get onBoarding2 => 'assets/animations/on_boarding_2.json';

  /// File path: assets/animations/on_boarding_3.json
  String get onBoarding3 => 'assets/animations/on_boarding_3.json';

  /// List of all assets
  List<String> get values => [
        error,
        initLoading,
        loading,
        noData,
        onBoarding1,
        onBoarding2,
        onBoarding3
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/logo copy.png
  AssetGenImage get logoCopy =>
      const AssetGenImage('assets/images/logo copy.png');

  /// File path: assets/images/logo-bg-removed.png
  AssetGenImage get logoBgRemoved =>
      const AssetGenImage('assets/images/logo-bg-removed.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/logo_1024.jpeg
  AssetGenImage get logo1024 =>
      const AssetGenImage('assets/images/logo_1024.jpeg');

  /// File path: assets/images/logo_512.jpeg
  AssetGenImage get logo512 =>
      const AssetGenImage('assets/images/logo_512.jpeg');

  /// List of all assets
  List<AssetGenImage> get values =>
      [logoCopy, logoBgRemoved, logo, logo1024, logo512];
}

class Assets {
  Assets._();

  static const String aEnv = '.env';
  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const String backup = 'assets/backup.isar';
  static const $AssetsImagesGen images = $AssetsImagesGen();

  /// List of all assets
  static List<String> get values => [aEnv, backup];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
