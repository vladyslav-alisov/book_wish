import 'dart:io';

import 'package:easy_book/const/assets.gen.dart';
import 'package:easy_book/l10n/translate_extension.dart';
import 'package:easy_book/main.dart';
import 'package:easy_book/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<Locale> _supportedLocales = [];

  String get _storeUrl => Platform.isIOS ? appStoreUrl : playMarketUrl;

  Map<ThemeMode, String> get _themeModeListToTitle => {
        ThemeMode.system: context.l10n.system,
        ThemeMode.dark: context.l10n.dark,
        ThemeMode.light: context.l10n.light,
      };

  List<ThemeMode> get _themeModeList => _themeModeListToTitle.keys.toList();

  late Locale _selectedLocale;
  late ThemeMode _selectedThemeMode;
  bool _isLoading = false;
  bool _isShareLoading = false;

  AppProvider get _appProvider => context.read<AppProvider>();

  @override
  void initState() {
    super.initState();
    _selectedLocale = _appProvider.appLocale;
    _selectedThemeMode = _appProvider.themeMode;
    _supportedLocales.addAll(AppLocalizations.supportedLocales);
  }

  void _onThemeModePress(ThemeMode newValue) async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      setState(() => _selectedThemeMode = newValue);
      await _appProvider.saveIsDarkThemeConfig(newValue);
    } catch (e) {
      if (mounted) showDialog(context: context, builder: (context) => AlertDialog(content: Text(e.toString())));
    } finally {
      _isLoading = false;
    }
  }

  void _onLanguageSelect(Locale newValue) async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      _selectedLocale = newValue;
      await _appProvider.saveLocaleConfig(newValue);
    } catch (e) {
      if (mounted) showDialog(context: context, builder: (context) => AlertDialog(content: Text(e.toString())));
    } finally {
      _isLoading = false;
    }
  }

  void _onAboutPress() {
    showAboutDialog(
      context: context,
      applicationName: _appProvider.appInfo.appName,
      applicationVersion: _appProvider.appInfo.version,
      children: [
        Text(
          context.l10n.aboutAppText,
        )
      ],
      applicationIcon: SizedBox(
        width: 70,
        height: 70,
        child: Image.asset(Assets.images.logo.path),
      ),
    );
  }

  void _onShareAppPress() async {
    if (_isShareLoading) return;
    setState(() => _isShareLoading = true);
    try {
      await Share.share(_storeUrl);
    } catch (e) {
      if (!mounted) return;
      AlertDialog(
        title: Text(context.l10n.error),
        content: Text(e.toString()),
      );
    } finally {
      setState(() => _isShareLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.settings,
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ExpansionTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(context.l10n.language),
            subtitle: Text(_selectedLocale.fullName()),
            children: List.generate(
              _supportedLocales.length,
              (index) => CheckboxListTile(
                title: Text(_supportedLocales[index].fullName()),
                value: _supportedLocales[index].languageCode == _selectedLocale.languageCode,
                onChanged: (val) => _onLanguageSelect(
                  _supportedLocales[index],
                ),
              ),
            ),
          ),
          ExpansionTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: Text(context.l10n.theme),
            subtitle: Text(_themeModeListToTitle[_selectedThemeMode] ?? ""),
            children: List.generate(
              _themeModeListToTitle.length,
              (index) => CheckboxListTile(
                title: Text(_themeModeListToTitle.values.toList()[index]),
                value: _themeModeList[index] == _selectedThemeMode,
                onChanged: (val) => _onThemeModePress(
                  _themeModeList[index],
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            onTap: _onAboutPress,
            title: Text(
              context.l10n.about,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            onTap: _onShareAppPress,
            title: Text(
              context.l10n.shareApp,
            ),
          ),
        ],
      ),
    );
  }
}
