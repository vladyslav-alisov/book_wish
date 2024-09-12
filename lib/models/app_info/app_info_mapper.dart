import 'package:easy_book/api/database/app_info_api/app_info_entity.dart';
import 'package:easy_book/models/app_info/app_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoMapper {
  static AppInfo dtoToModel(PackageInfo packageInfo) {
    return AppInfo(
      packageInfo.appName,
      packageInfo.packageName,
      packageInfo.version,
      packageInfo.buildNumber,
      packageInfo.buildSignature,
      DateTime.now(),
    );
  }

  static AppInfoEntity modelToEntity(AppInfo model) {
    return AppInfoEntity(
      model.appName,
      model.packageName,
      model.version,
      model.buildNumber,
      model.buildSignature,
      model.lastUpdated,
    );
  }

  static AppInfo entityToModel(AppInfoEntity entity) {
    return AppInfo(
      entity.appName,
      entity.packageName,
      entity.version,
      entity.buildNumber,
      entity.buildSignature,
      entity.lastUpdated,
    );
  }
}
