import 'package:isar/isar.dart';
import '../../domain/entities/note_entity.dart';

part 'note_model.g.dart';

@Collection()
class NoteModel {
  Id id = Isar.autoIncrement;
  String title;
  String content;
  DateTime createdAt;

  NoteModel({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  NoteEntity toEntity() => NoteEntity(
        id: id,
        title: title,
        content: content,
        createdAt: createdAt,
      );

  static NoteModel fromEntity(NoteEntity entity) => NoteModel(
        title: entity.title,
        content: entity.content,
        createdAt: entity.createdAt,
      );
}