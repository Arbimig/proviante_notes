import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../data_source/note_data_source.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteDataSource dataSource;

  NoteRepositoryImpl(this.dataSource);

  @override
  Future<List<NoteEntity>> getNotes() async {
    return await dataSource.getNotes();
  }

  @override
  Future<void> addNote(NoteEntity note) async {
    await dataSource.saveNote(note);
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    await dataSource.saveNote(note);
  }

  @override
  Future<void> deleteNote(int id) async {
    await dataSource.deleteNote(id);
  }
}
