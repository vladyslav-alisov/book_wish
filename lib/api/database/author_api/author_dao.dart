import 'package:easy_book/api/database/author_api/author_entity.dart';
import 'package:isar/isar.dart';

class AuthorDao {
  final Isar _isar;

  AuthorDao(this._isar);

  Future<List<AuthorEntity>> getAuthorList(int offset, int limit, {String? input}) async {
    List<AuthorEntity> authorEntityList = await _isar.authorEntitys
        .filter()
        .optional(
          input != null,
          (q) => q.nameContains(input!),
        )
        .offset(offset)
        .limit(limit)
        .findAll();
    return authorEntityList;
  }
}
