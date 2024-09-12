import 'package:easy_book/api/database/author_api/author_entity.dart';
import 'package:easy_book/api/database/genre_api/genre_entity.dart';
import 'package:isar/isar.dart';

part 'book_entity.g.dart';

@collection
class BookEntity {
  Id id = Isar.autoIncrement;
  @Index()
  final String title;
  final String imageUrl;
  IsarLink<AuthorEntity> author = IsarLink<AuthorEntity>();
  final IsarLinks<GenreEntity> genre = IsarLinks<GenreEntity>();
  final String description;
  final String publicationDate;
  final double rating;
  final DateTime createdAt = DateTime.now();
  bool didRead;
  bool isFavourite;

  BookEntity({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.publicationDate,
    required this.rating,
    this.didRead = false,
    this.isFavourite = false,
  });

  @override
  String toString() {
    return 'BookEntity{id: $id, title: $title, imageUrl: $imageUrl, author: $author, genre: $genre, description: $description, publicationDate: $publicationDate, rating: $rating, createdAt: $createdAt, didRead: $didRead, isFavourite: $isFavourite}';
  }
}
