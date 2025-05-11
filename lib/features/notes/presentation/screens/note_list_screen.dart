import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proviante_notes/features/theme/presentation/widgets/theme_toggle.dart';

import '../../../../core/config/env.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import '../widgets/note_card.dart';
import '../widgets/note_search.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes ${Env.noteStorageType.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NoteSearchDelegate());
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              context.read<NoteBloc>().add(const SortNotesEvent(true));
            },
          ),
          ThemeToggle(),
        ],
      ),
      body: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) => {
          if (state is NoteError)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              )
            }
        },
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NoteLoaded) {
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return Dismissible(
                  key: Key("${note.id}"),
                  onDismissed: (_) {
                    context.read<NoteBloc>().add(DeleteNoteEvent(note.id));
                  },
                  child: NoteCard(
                    note: note,
                    trailing: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                          onTap: () => context.read<NoteBloc>().add(DeleteNoteEvent(note.id)),
                          child: Icon(Icons.delete_outline_rounded)),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No notes'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteEditScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
