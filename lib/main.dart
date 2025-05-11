import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/env.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/notes/presentation/bloc/note_bloc.dart';
import 'features/notes/presentation/bloc/note_event.dart';
import 'features/notes/presentation/screens/note_list_screen.dart';
import 'features/theme/presentation/bloc/theme_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(Env.noteStorageType);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<ThemeCubit>()..loadTheme()),
        BlocProvider(create: (_) => locator<NoteBloc>()..add(LoadNotesEvent())),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Notes App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state ? ThemeMode.dark : ThemeMode.light,
            home: NoteListScreen(),
          );
        },
      ),
    );
  }
}
