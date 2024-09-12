import 'package:easy_book/models/author/author.dart';
import 'package:easy_book/models/genre/genre.dart';

class Book {
  final int dbId;
  final Author author;
  final List<Genre> genre;
  final String title;
  final String description;
  final String publicationDate;
  final String image;
  final double rating;
  final bool didRead;
  final bool isFavourite;

  Book({
    required this.dbId,
    required this.author,
    required this.genre,
    required this.title,
    required this.description,
    required this.publicationDate,
    required this.image,
    required this.rating,
    required this.didRead,
    required this.isFavourite,
  });
}
