import 'package:easy_book/api/database/database_client.dart';
import 'package:easy_book/api/secure_storage/storage_client.dart';
import 'package:easy_book/models/app_config/app_config.dart';
import 'package:easy_book/models/app_info/app_info.dart';
import 'package:easy_book/repositories/app_repository.dart';
import 'package:easy_book/utils/app_env.dart';
import 'package:easy_book/view/app_error.dart';
import 'package:flutter/material.dart';

import 'view/app.dart';

const String appStoreUrl = "https://apps.apple.com/tr/app/flickermail/id6476929326";
const String playMarketUrl = "https://play.google.com/store/apps/details?id=com.flickermail.app";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AppEnv.init();
    await SecureStorageClient.initSecureStorage();
    DatabaseClient dbClient = await DatabaseClient.initLocalDatabase();

    final AppRepository appRepository = AppRepository(dbClient);
    AppConfig initAppConfig = await appRepository.getAppConfig();
    AppInfo appInfo = await appRepository.getAppInfo();

    runApp(App(initConfig: initAppConfig, appRepository: appRepository, appInfo: appInfo));
  } catch (e) {
    runApp(AppError(error: e));
  }
}
