  // import '../../domain/entities/note_entity.dart';
  // import '../data_source/isar_data_source.dart';
  // import '../models/note_model.dart';
  // import '../../domain/repositories/note_repository.dart';

  // class IsarRepository implements NoteRepository {
  //   final IsarDataSource dataSource;

  //   IsarRepository(this.dataSource);

  //   @override
  //   Future<List<NoteEntity>> getNotes() async {
  //     try {
  //       final models = await dataSource.getNotes();
  //       return models.map((model) => model.toEntity()).toList();
  //     } catch (e) {
  //       throw Exception('Failed to load notes: $e');
  //     }
  //   }

  //   @override
  //   Future<void> addNote(NoteEntity note) async {
  //     try {
  //       await dataSource.saveNote(NoteModel.fromEntity(note));
  //     } catch (e) {
  //       throw Exception('Failed to add note: $e');
  //     }
  //   }

  //   @override
  //   Future<void> updateNote(NoteEntity note) async {
  //     try {
  //       final model = NoteModel.fromEntity(note);
  //       model.id = note.id;
  //       await dataSource.saveNote(model);
  //     } catch (e) {
  //       throw Exception('Failed to update note: $e');
  //     }
  //   }

  //   @override
  //   Future<void> deleteNote(int id) async {
  //     try {
  //       await dataSource.deleteNote(id);
  //     } catch (e) {
  //       throw Exception('Failed to delete note: $e');
  //     }
  //   }
  // }
