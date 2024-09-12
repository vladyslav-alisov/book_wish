import 'package:easy_book/api/database/author_api/author_entity.dart';
import 'package:easy_book/models/author/author.dart';

class AuthorMapper {
  Author mapEntityToModel(AuthorEntity entity) {
    return Author(
      dbId: entity.id,
      name: entity.name,
    );
  }
}
