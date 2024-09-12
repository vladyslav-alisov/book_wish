import 'dart:io';

import 'package:easy_book/api/database/app_config_api/app_config_dao.dart';
import 'package:easy_book/api/database/app_config_api/app_config_entity.dart';
import 'package:easy_book/api/database/app_info_api/app_info_dao.dart';
import 'package:easy_book/api/database/app_info_api/app_info_entity.dart';
import 'package:easy_book/api/database/author_api/author_dao.dart';
import 'package:easy_book/api/database/author_api/author_entity.dart';
import 'package:easy_book/api/database/book_api/book_dao.dart';
import 'package:easy_book/api/database/book_api/book_entity.dart';
import 'package:easy_book/api/database/genre_api/genre_dao.dart';
import 'package:easy_book/api/database/genre_api/genre_entity.dart';
import 'package:easy_book/const/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DatabaseClient {
  static DatabaseClient? _instance;

  late final AppConfigDao appConfigDao;
  late final AppInfoDao appInfoDao;
  late final BookDao bookDao;
  late final AuthorDao authorDao;
  late final GenreDao genreDao;
  late final Isar _isar;

  static DatabaseClient get instance => _instance != null ? _instance! : throw Exception("Initialize database first!");

  DatabaseClient(Isar isar) {
    _isar = isar;
    appConfigDao = AppConfigDao(isar);
    appInfoDao = AppInfoDao(isar);
    bookDao = BookDao(isar);
    authorDao = AuthorDao(isar);
    genreDao = GenreDao(isar);
  }

  Future<void> createCopy() async {
    final backUpDir = await getApplicationSupportDirectory();

    final File backUpFile = File('${backUpDir.path}/backup.isar');
    print(backUpDir);
    if (await backUpFile.exists()) {
      // if already we have another backup file, delete it here.
      await backUpFile.delete();
    }
    await _isar.copyToFile('${backUpDir.path}/backup.isar');
    await Share.shareXFiles([XFile(backUpFile.path)]);
  }

  static Future<DatabaseClient> initLocalDatabase() async {
    if (_instance == null) {
      String path = await _loadDBFromAssets();
      Directory appDocDir = await getApplicationDocumentsDirectory();

      Isar isar = await Isar.open(
        [
          AppConfigEntitySchema,
          AppInfoEntitySchema,
          BookEntitySchema,
          AuthorEntitySchema,
          GenreEntitySchema,
        ],
        directory: appDocDir.path,
      );
      _instance = DatabaseClient(isar);
    }
    return _instance!;
  }

  static Future<String> _loadDBFromAssets() async {
    String defaultPath = await _getDBDefaultPath();
    File file = File(defaultPath);
    bool fileExists = await file.exists();
    if (!fileExists) {
      ByteData data = await rootBundle.load(Assets.backup);
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(defaultPath).writeAsBytes(bytes);
    }

    return defaultPath;
  }

  static Future<String> _getDBDefaultPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = "${appDocDir.path}/default.isar";
    return path;
  }
}
