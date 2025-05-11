import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import '../widgets/note_card.dart';

class NoteSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(backgroundColor: theme.appBarTheme.backgroundColor),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.white70),
      ),
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
      textTheme: theme.textTheme.copyWith(titleLarge: const TextStyle(color: Colors.white)),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          context.read<NoteBloc>().add(SearchNotesEvent(''));
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteLoaded && state.filteredNotes.isNotEmpty && query.isNotEmpty) {
          return ListView.builder(
            itemCount: state.filteredNotes.length,
            itemBuilder: (context, index) {
              final note = state.filteredNotes[index];
              return NoteCard(note: note);
            },
          );
        }
        return const Center(child: Text('No results'));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      context.read<NoteBloc>().add(SearchNotesEvent(query));
    } else {
      context.read<NoteBloc>().add(SearchNotesEvent(''));
    }

    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteLoaded) {
          return ListView.builder(
            itemCount: state.filteredNotes.length,
            itemBuilder: (context, index) {
              final note = state.filteredNotes[index];
              return NoteCard(note: note);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
