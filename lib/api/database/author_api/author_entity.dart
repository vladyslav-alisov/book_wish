import 'package:isar/isar.dart';

part 'author_entity.g.dart';

@collection
class AuthorEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late final String name;

  AuthorEntity();
}
