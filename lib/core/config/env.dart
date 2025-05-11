enum NoteStorageType {
  isar,
  shared,
}

class Env {
  static final NoteStorageType noteStorageType = _getNoteStorageType();

  static NoteStorageType _getNoteStorageType() {
    const storageType = String.fromEnvironment('NOTE_STORAGE_TYPE', defaultValue: 'isar');
    switch (storageType) {
      case 'isar':
        return NoteStorageType.isar;
      case 'shared':
        return NoteStorageType.shared;
      default:
        throw Exception('Unknown NOTE_STORAGE_TYPE: $storageType');
    }
  }
}