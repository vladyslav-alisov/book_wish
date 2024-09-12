import 'package:isar/isar.dart';

part 'genre_entity.g.dart';

@collection
class GenreEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late final String name;

  GenreEntity();
}
