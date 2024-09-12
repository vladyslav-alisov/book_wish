import 'dart:io';

import 'package:easy_book/api/database/app_config_api/app_config_dao.dart';
import 'package:easy_book/api/database/app_config_api/app_config_entity.dart';
import 'package:easy_book/api/database/app_info_api/app_info_dao.dart';
import 'package:easy_book/api/database/app_info_api/app_info_entity.dart';
import 'package:easy_book/api/database/database_client.dart';
import 'package:easy_book/models/app_config/app_config.dart';
import 'package:easy_book/models/app_config/app_config_mapper.dart';
import 'package:easy_book/models/app_info/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppRepository {
  AppRepository(DatabaseClient dbClient) {
    _appConfigDao = dbClient.appConfigDao;
    _appInfoDao = dbClient.appInfoDao;
  }

  final AppConfigMapper _appConfigMapper = AppConfigMapper();

  late final AppConfigDao _appConfigDao;
  late final AppInfoDao _appInfoDao;

  Future<AppConfig> getAppConfig() async {
    AppConfigEntity? appConfigDBEntity = await _appConfigDao.getAppConfig();
    if (appConfigDBEntity != null) {
      return _appConfigMapper.entityToModel(appConfigDBEntity);
    } else {
      Locale initLocale = _getInitLocale();
      ThemeMode themeMode = ThemeMode.system;
      AppConfig newAppConfig = AppConfig(true, initLocale, themeMode);
      AppConfig updatedAppConfig = await updateAppConfig(newAppConfig);
      return updatedAppConfig;
    }
  }

  /// Checks system prefs, if not supported, returns default app's Locale
  Locale _getInitLocale() {
    final String systemLang = Platform.localeName;
    Locale systemLocale = Locale(systemLang.split("_").first);
    bool isSupported = AppLocalizations.delegate.isSupported(systemLocale);
    return isSupported ? systemLocale : AppLocalizations.supportedLocales.first;
  }

  Future<AppConfig> updateAppConfig(AppConfig appConfig) async {
    AppConfigEntity appConfigDBEntity = _appConfigMapper.modelToEntity(appConfig);
    await _appConfigDao.deleteAllConfigEntity();
    await _appConfigDao.saveAppConfig(appConfigDBEntity);
    return appConfig;
  }

  Future<AppInfo> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppInfoEntity? appVersion = await _appInfoDao.getAppInfo();
    if (appVersion != null && appVersion.version == packageInfo.version) {
      AppInfo saveAppInfo = AppInfoMapper.entityToModel(appVersion);
      return saveAppInfo;
    } else {
      AppInfo updatedAppInfo = AppInfoMapper.dtoToModel(packageInfo);
      AppInfoEntity updatedAppInfoDBEntity = AppInfoMapper.modelToEntity(updatedAppInfo);
      if (appVersion != null) await _appInfoDao.deleteAllConfigEntity();
      await _appInfoDao.saveAppInfo(updatedAppInfoDBEntity);
      return updatedAppInfo;
    }
  }
}
