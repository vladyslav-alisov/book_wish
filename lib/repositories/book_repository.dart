import 'package:easy_book/api/database/author_api/author_dao.dart';
import 'package:easy_book/api/database/author_api/author_entity.dart';
import 'package:easy_book/api/database/book_api/book_dao.dart';
import 'package:easy_book/api/database/book_api/book_entity.dart';
import 'package:easy_book/api/database/database_client.dart';
import 'package:easy_book/api/database/genre_api/genre_dao.dart';
import 'package:easy_book/api/database/genre_api/genre_entity.dart';
import 'package:easy_book/models/author/author.dart';
import 'package:easy_book/models/author/author_mapper.dart';
import 'package:easy_book/models/book/book.dart';
import 'package:easy_book/models/book/book_mapper.dart';
import 'package:easy_book/models/genre/genre.dart';
import 'package:easy_book/models/genre/genre_mapper.dart';

class BookRepository {
  final BookDao _bookDao = DatabaseClient.instance.bookDao;
  final AuthorDao _authorDao = DatabaseClient.instance.authorDao;
  final GenreDao _genreDao = DatabaseClient.instance.genreDao;

  final BookMapper _bookMapper = BookMapper();
  final AuthorMapper _authorMapper = AuthorMapper();
  final GenreMapper _genreMapper = GenreMapper();

  Future<List<Book>> searchBooks(
    int limit,
    int offset,
    String? input,
    int? authorId,
    int? genreId,
    bool? didRead,
  ) async {
    List<BookEntity> bookEntityList = await _bookDao.searchBooks(
      offset: offset,
      limit: limit,
      input: input,
      authorId: authorId,
      genreId: genreId,
      didRead: didRead,
    );
    List<Book> bookList = await _loadReferencesAndMapToModel(bookEntityList);
    return bookList;
  }

  Future<List<Book>> getFavoriteBooks(int offset, int limit) async {
    List<BookEntity> bookEntityList = await _bookDao.searchBooks(
      offset: offset,
      limit: limit,
      isFavourite: true,
    );
    return await _loadReferencesAndMapToModel(bookEntityList);
  }

  Future<List<Book>> getAlreadyReadBooks(int offset, int limit) async {
    List<BookEntity> bookEntityList = await _bookDao.searchBooks(
      offset: offset,
      limit: limit,
      didRead: true,
    );
    return await _loadReferencesAndMapToModel(bookEntityList);
  }

  Future<List<Book>> _loadReferencesAndMapToModel(List<BookEntity> entityBooks) async {
    List<Book> books = [];
    for (var entity in entityBooks) {
      await entity.author.load();
      AuthorEntity? authorEntity = entity.author.value;
      Author author =
          authorEntity != null ? _authorMapper.mapEntityToModel(authorEntity) : Author(name: "Unknown", dbId: 1);

      await entity.genre.load();
      List<Genre> genreList = [];
      for (var genreEntity in entity.genre) {
        genreList.add(_genreMapper.mapEntityToModel(genreEntity));
      }

      Book book = _bookMapper.mapEntityToModel(entity, author, genreList);
      books.add(book);
    }
    return books;
  }

  Future<List<Author>> searchAuthors(int offset, int limit, {String? input}) async {
    List<AuthorEntity> authorEntityList = await _authorDao.getAuthorList(offset, limit, input: input);
    List<Author> authors = authorEntityList.map((e) => _authorMapper.mapEntityToModel(e)).toList();
    return authors;
  }

  Future<List<Genre>> searchGenres(int offset, int limit, {String? input}) async {
    List<GenreEntity> genreEntityList = await _genreDao.getGenreList(offset, limit, input: input);
    List<Genre> genre = genreEntityList.map((e) => _genreMapper.mapEntityToModel(e)).toList();
    return genre;
  }

  Future<Book> changeFavoriteStatus(int dbId) async {
    BookEntity bookEntity = await _bookDao.updateIsFavorite(dbId);
    return (await _loadReferencesAndMapToModel([bookEntity])).first;
  }

  Future<Book> changeDidReadStatus(int dbId) async {
    BookEntity bookEntity = await _bookDao.updateDidRead(dbId);
    return (await _loadReferencesAndMapToModel([bookEntity])).first;
  }
}
