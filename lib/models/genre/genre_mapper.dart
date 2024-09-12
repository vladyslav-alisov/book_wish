import 'package:easy_book/api/database/genre_api/genre_entity.dart';
import 'package:easy_book/models/genre/genre.dart';

class GenreMapper {
  Genre mapEntityToModel(GenreEntity entity) {
    return Genre(
      dbId: entity.id,
      name: entity.name,
    );
  }
}
