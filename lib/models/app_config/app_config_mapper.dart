import 'package:flutter/material.dart';
import 'package:template/api/local/database/app_config_api/app_config_db_entity.dart';
import 'package:template/models/app_config/app_config.dart';

class AppConfigMapper {
  static AppConfigDBEntity fromAppConfigToAppConfigDBEntity(AppConfig appConfig) {
    return AppConfigDBEntity(
        appConfig.locale.languageCode, appConfig.locale.countryCode, appConfig.isFirstLaunch, appConfig.isDarkTheme);
  }

  static AppConfig fromAppConfigDBEntityToAppConfig(AppConfigDBEntity appConfigEntity) {
    Locale locale = Locale(appConfigEntity.languageCode, appConfigEntity.countryCode);
    return AppConfig(appConfigEntity.isFirstLaunch, locale, appConfigEntity.isDarkTheme);
  }
}