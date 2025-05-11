import 'package:get_it/get_it.dart';

import '../../features/notes/data/data_source/impl/isar_note_data_source.dart';
import '../../features/notes/data/data_source/impl/shared_prefs_note_data_source.dart';
import '../../features/notes/data/data_source/note_data_source.dart';
import '../../features/notes/data/repositories/note_repository_impl.dart';
import '../../features/notes/domain/repositories/note_repository.dart';
import '../../features/notes/presentation/bloc/note_bloc.dart';
import '../../features/theme/presentation/bloc/theme_cubit.dart';
import '../config/env.dart';

final locator = GetIt.instance;

NoteDataSource _createNoteDataSource(NoteStorageType type) {
  switch (type) {
    case NoteStorageType.shared:
      return SharedPrefsNoteDataSource();
    case NoteStorageType.isar:
      return IsarNoteDataSource();
  }
}

void setupLocator(NoteStorageType type) {
  // Data Sources
  locator.registerLazySingleton<NoteDataSource>(() => _createNoteDataSource(type));

  // Repositories
  locator.registerLazySingleton<NoteRepository>(() => NoteRepositoryImpl(locator()));

  // Blocs
  locator.registerFactory(() => NoteBloc(repository: locator()));
  locator.registerFactory(() => ThemeCubit());
}
