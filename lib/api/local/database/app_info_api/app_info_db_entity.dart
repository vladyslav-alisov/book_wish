import 'package:isar/isar.dart';
part 'app_info_db_entity.g.dart';

@collection
class AppInfoDBEntity {
  final Id localeId = Isar.autoIncrement;
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final String buildSignature;
  final DateTime lastUpdated;

  AppInfoDBEntity(
    this.appName,
    this.packageName,
    this.version,
    this.buildNumber,
    this.buildSignature,
    this.lastUpdated,
  );
}