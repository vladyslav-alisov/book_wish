import 'package:easy_book/models/book/book.dart';
import 'package:easy_book/repositories/book_repository.dart';
import 'package:flutter/cupertino.dart';

class BookProvider extends ChangeNotifier {
  BookProvider(this._bookRepository);

  final BookRepository _bookRepository;

  final List<Book> _books = [];
  final List<Book> _favoriteBooks = [];
  final List<Book> _alreadyRead = [];

  List<Book> get books => _books;
  List<Book> get favoriteBooks => _favoriteBooks;
  List<Book> get alreadyRead => _alreadyRead;

  Future<void> initBooks(int offset, int limit) async {
    List<Book> books = await _bookRepository.searchBooks(limit, offset, null, null, null, null);

    if (books.isNotEmpty) {
      _books.addAll(books);
    }
    notifyListeners();
  }

  Future<void> initFetchFavoriteBooks(int offset, int limit) async {
    _favoriteBooks.clear();
    List<Book> favoriteBooks = await _bookRepository.getFavoriteBooks(offset, limit);
    _favoriteBooks.addAll(favoriteBooks);
    notifyListeners();
  }

  Future<void> fetchFavoriteBooks(int offset, int limit) async {
    List<Book> favoriteBooks = await _bookRepository.getFavoriteBooks(offset, limit);
    _favoriteBooks.addAll(favoriteBooks);
    notifyListeners();
  }

  Future<void> initFetchAlreadyReadBooks(int offset, int limit) async {
    _alreadyRead.clear();
    List<Book> alreadyReadBooks = await _bookRepository.getAlreadyReadBooks(offset, limit);
    _alreadyRead.addAll(alreadyReadBooks);
    notifyListeners();
  }

  Future<void> fetchAlreadyReadBooks(int offset, int limit) async {
    List<Book> alreadyReadBooks = await _bookRepository.getAlreadyReadBooks(offset, limit);
    _alreadyRead.addAll(alreadyReadBooks);
    notifyListeners();
  }

  Future<void> fetchMore(int offset, int limit, {String? input}) async {
    List<Book> books = await _bookRepository.searchBooks(limit, offset, input, null, null, null);
    if (books.isNotEmpty) {
      _books.addAll(books);
    }
    notifyListeners();
  }

  Future<void> changeFavoriteStatus(int dbId) async {
    Book book = await _bookRepository.changeFavoriteStatus(dbId);
    int index = _books.indexWhere((element) => element.dbId == dbId);
    if (index != -1) {
      _books[index] = book;
      if (book.isFavourite) {
        _favoriteBooks.add(book);
      } else {
        _favoriteBooks.removeWhere((element) => element.dbId == book.dbId);
      }
      notifyListeners();
    }
  }

  Future<void> changeDidReadStatus(int dbId) async {
    Book book = await _bookRepository.changeDidReadStatus(dbId);
    int index = _books.indexWhere((element) => element.dbId == dbId);
    if (index != -1) {
      _books[index] = book;
      if (book.didRead) {
        _alreadyRead.add(book);
      } else {
        _alreadyRead.removeWhere(
          (element) => element.dbId == book.dbId,
        );
      }
      notifyListeners();
    }
  }
}
