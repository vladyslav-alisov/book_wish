import 'package:easy_book/api/database/app_config_api/app_config_entity.dart';
import 'package:isar/isar.dart';

class AppConfigDao {
  final Isar _isar;

  AppConfigDao(this._isar);

  Future<AppConfigEntity?> getAppConfig() async {
    AppConfigEntity? appConfigDBEntity = await _isar.appConfigEntitys.where().findFirst();
    return appConfigDBEntity;
  }

  Future<void> saveAppConfig(AppConfigEntity appConfigDBEntity) async {
    await _isar.writeTxn(() async {
      await _isar.appConfigEntitys.put(appConfigDBEntity);
    });
  }

  Future<void> deleteAllConfigEntity() async {
    await _isar.writeTxn(() async {
      await _isar.appConfigEntitys.clear();
    });
  }
}
