import 'package:easy_book/api/database/app_config_api/app_config_entity.dart';
import 'package:easy_book/models/app_config/app_config.dart';
import 'package:flutter/material.dart';

class AppConfigMapper {
  AppConfigEntity modelToEntity(AppConfig appConfig) {
    return AppConfigEntity(
      appConfig.locale.languageCode,
      appConfig.locale.countryCode,
      appConfig.isFirstLaunch,
      appConfig.themeMode,
    );
  }

  AppConfig entityToModel(AppConfigEntity appConfigEntity) {
    Locale locale = Locale(
      appConfigEntity.languageCode,
      appConfigEntity.countryCode,
    );

    return AppConfig(
      appConfigEntity.isFirstLaunch,
      locale,
      appConfigEntity.themeMode,
    );
  }
}
