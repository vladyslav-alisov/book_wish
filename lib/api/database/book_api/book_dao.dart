import 'package:easy_book/api/database/author_api/author_entity.dart';
import 'package:easy_book/api/database/book_api/book_entity.dart';
import 'package:easy_book/api/database/genre_api/genre_entity.dart';
import 'package:isar/isar.dart';

class BookDao {
  final Isar _isar;

  BookDao(this._isar);

  Future<List<BookEntity>> searchBooks({
    required int offset,
    required int limit,
    String? input,
    int? authorId,
    int? genreId,
    bool? isFavourite,
    bool? didRead,
  }) async {
    final queryResult = await _isar.bookEntitys
        .where()
        .filter()
        .optional(didRead != null, (q) => q.didReadEqualTo(didRead!))
        .optional(isFavourite != null, (q) => q.isFavouriteEqualTo(isFavourite!))
        .optional(authorId != null, (q) => q.author((q) => q.idEqualTo(authorId!)))
        .optional(genreId != null, (q) => q.genre((q) => q.idEqualTo(genreId!)))
        .optional(
          input != null && input.isNotEmpty,
          (q) => q
              .titleContains(input!, caseSensitive: false)
              .or()
              .optional(genreId == null, (q) => q.genre((q) => q.nameContains(input, caseSensitive: false)))
              .or()
              .optional(authorId == null, (q) => q.author((q) => q.nameContains(input, caseSensitive: false))),
        )
        .offset(offset)
        .limit(limit)
        .findAll();

    return queryResult;

    return queryResult;
  }

  Future<BookEntity> updateIsFavorite(int id, {bool isFavorite = true}) async {
    BookEntity bookEntity = await _isar.writeTxn(() async {
      BookEntity? bookEntity = await _isar.bookEntitys.get(id);
      if (bookEntity == null) throw Exception("Book does not exist");
      bookEntity.isFavourite = !bookEntity.isFavourite;
      await _isar.bookEntitys.put(bookEntity);
      return bookEntity;
    });
    return bookEntity;
  }

  Future<BookEntity> updateDidRead(int id, {bool didRead = true}) async {
    BookEntity bookEntity = await _isar.writeTxn(() async {
      BookEntity? bookEntity = await _isar.bookEntitys.get(id);
      if (bookEntity == null) throw Exception("Book does not exist");
      bookEntity.didRead = !bookEntity.didRead;
      await _isar.bookEntitys.put(bookEntity);
      return bookEntity;
    });
    return bookEntity;
  }
}
