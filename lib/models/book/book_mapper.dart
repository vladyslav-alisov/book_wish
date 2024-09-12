import 'package:easy_book/api/database/book_api/book_entity.dart';
import 'package:easy_book/models/author/author.dart';
import 'package:easy_book/models/book/book.dart';
import 'package:easy_book/models/genre/genre.dart';

class BookMapper {
  Book mapEntityToModel(BookEntity entity, Author author, List<Genre> genreList) {
    return Book(
      image: entity.imageUrl,
      dbId: entity.id,
      title: entity.title,
      description: entity.description,
      publicationDate: entity.publicationDate,
      rating: entity.rating.toDouble(),
      didRead: entity.didRead,
      isFavourite: entity.isFavourite,
      author: author,
      genre: genreList,
    );
  }
}
