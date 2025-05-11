import 'dart:async';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/entities/note_entity.dart';
import '../../models/note_model.dart';
import '../note_data_source.dart';

class IsarNoteDataSource implements NoteDataSource {
  late Future<Isar> _isar;
  final _changeController = StreamController<bool>.broadcast();

  IsarNoteDataSource() {
    _isar = _initIsar();
    _setupWatcher();
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [NoteModelSchema],
      directory: dir.path,
    );
  }

  Future<void> _setupWatcher() async {
    final isar = await _isar;
    isar.noteModels.watchLazy().listen((_) {
      _changeController.add(true);
    });
  }

  Stream<bool> get onChange => _changeController.stream;

  @override
  Future<List<NoteEntity>> getNotes() async {
    final isar = await _isar;
    final models = await isar.noteModels.where().findAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveNote(NoteEntity note) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.noteModels.put(NoteModel.fromEntity(note));
    });
  }

  @override
  Future<void> deleteNote(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.noteModels.delete(id);
    });
  }

  void dispose() {
    _changeController.close();
  }
}
