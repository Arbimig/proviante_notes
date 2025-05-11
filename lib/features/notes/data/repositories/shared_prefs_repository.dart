// import '../../domain/entities/note_entity.dart';
// import '../data_source/shared_prefs_data_source.dart';
// import '../../domain/repositories/note_repository.dart';

// class SharedPrefsRepository implements NoteRepository {
//   final SharedPrefsDataSource dataSource;

//   SharedPrefsRepository(this.dataSource);

//   @override
//   Future<List<NoteEntity>> getNotes() async {
//     try {
//       final models = await dataSource.getNotes();
//       return models;
//     } catch (e) {
//       throw Exception('Failed to load notes: $e');
//     }
//   }

//   @override
//   Future<void> addNote(NoteEntity note) async {
//     try {
//       final models = await dataSource.getNotes();
//       models.add(note);
//       await dataSource.saveNotes(models);
//     } catch (e) {
//       throw Exception('Failed to add note: $e');
//     }
//   }

//   @override
//   Future<void> updateNote(NoteEntity note) async {
//     try {
//       final models = await dataSource.getNotes();
//       final index = models.indexWhere((m) => m.id.toString() == note.id);
//       if (index != -1) {
//         models[index] = note;
//         await dataSource.saveNotes(models);
//       }
//     } catch (e) {
//       throw Exception('Failed to update note: $e');
//     }
//   }

//   @override
//   Future<void> deleteNote(int id) async {
//     try {
//       final models = await dataSource.getNotes();
//       models.removeWhere((m) => m.id.toString() == id);
//       await dataSource.saveNotes(models);
//     } catch (e) {
//       throw Exception('Failed to delete note: $e');
//     }
//   }
// }
