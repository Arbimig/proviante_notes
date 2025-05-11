import '../../domain/entities/note_entity.dart';

abstract class NoteDataSource {
  Future<List<NoteEntity>> getNotes();
  Future<void> saveNote(NoteEntity note);
  Future<void> deleteNote(int id);
}