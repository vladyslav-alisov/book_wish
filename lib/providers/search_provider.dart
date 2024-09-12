import 'package:easy_book/models/author/author.dart';
import 'package:easy_book/models/book/book.dart';
import 'package:easy_book/models/genre/genre.dart';
import 'package:easy_book/repositories/book_repository.dart';
import 'package:flutter/cupertino.dart';

class SearchProvider extends ChangeNotifier {
  final BookRepository _bookRepository;

  final List<Book> _books = [];

  List<Book> get searchBooks => _books;

  SearchProvider(this._bookRepository);

  Author? filterAuthor;

  Genre? filterGenre;

  bool? filterDidRead;

  void setAuthorFilter(Author? author) {
    filterAuthor = author;
  }

  void setGenreFilter(Genre? genre) {
    filterGenre = genre;
  }

  void clearAuthorFilter() {
    filterAuthor = null;
    search(0, 20);
  }

  void clearGenreFilter() {
    filterGenre = null;
    search(0, 20);
  }

  void resetFilters() {
    filterGenre = null;
    filterAuthor = null;
    search(0, 20);
  }

  Future<void> search(int offset, int limit, {String? input}) async {
    _books.clear();
    List<Book> books = await _bookRepository.searchBooks(
      limit,
      offset,
      input,
      filterAuthor?.dbId,
      filterGenre?.dbId,
      filterDidRead,
    );
    if (books.isNotEmpty) {
      _books.addAll(books);
    }
    notifyListeners();
  }

  Future<void> fetchMore(int offset, int limit, {String? input}) async {
    List<Book> books = await _bookRepository.searchBooks(
      limit,
      offset,
      input,
      filterAuthor?.dbId,
      filterGenre?.dbId,
      filterDidRead,
    );
    if (books.isNotEmpty) {
      _books.addAll(books);
    }
    notifyListeners();
  }

  Future<List<Book>> searchSuggestions(String input) async {
    List<Book> books = await _bookRepository.searchBooks(
      20,
      0,
      input,
      filterAuthor?.dbId,
      filterGenre?.dbId,
      filterDidRead,
    );
    return books;
  }

  Future<List<Author>> searchAuthors(int offset, String input) async {
    List<Author> authors = await _bookRepository.searchAuthors(offset, 20, input: input);
    return authors;
  }

  Future<List<Genre>> searchGenre(int offset, String input) async {
    List<Genre> genre = await _bookRepository.searchGenres(offset, 20, input: input);
    return genre;
  }

  void resetSearch() {
    _books.clear();
    filterAuthor = null;
    filterGenre = null;
    filterDidRead = null;
  }
}
