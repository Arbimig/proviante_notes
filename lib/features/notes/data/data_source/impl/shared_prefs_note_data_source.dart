import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/note_entity.dart';
import '../note_data_source.dart';

class SharedPrefsNoteDataSource implements NoteDataSource {
  static const _notesKey = 'notes';

  @override
  Future<List<NoteEntity>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];
    return notesJson
        .map((json) => NoteEntity.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> saveNote(NoteEntity note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      notes[index] = note;
    } else {
      notes.add(note);
    }
    await prefs.setStringList(
      _notesKey,
      notes.map((n) => jsonEncode(n.toJson())).toList(),
    );
  }

  @override
  Future<void> deleteNote(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    notes.removeWhere((note) => note.id == id);
    await prefs.setStringList(
      _notesKey,
      notes.map((n) => jsonEncode(n.toJson())).toList(),
    );
  }
}