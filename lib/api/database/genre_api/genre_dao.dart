import 'package:easy_book/api/database/genre_api/genre_entity.dart';
import 'package:isar/isar.dart';

class GenreDao {
  final Isar _isar;

  GenreDao(this._isar);

  Future<List<GenreEntity>> getGenreList(int offset, int limit, {String? input}) async {
    List<GenreEntity> authorEntityList = await _isar.genreEntitys
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
