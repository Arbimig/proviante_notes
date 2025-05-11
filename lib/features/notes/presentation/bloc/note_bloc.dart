import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:proviante_notes/features/notes/data/data_source/impl/isar_note_data_source.dart';
import 'package:rxdart/transformers.dart';

import '../../data/repositories/note_repository_impl.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository repository;
  late final StreamSubscription<bool> _changeSubscription;

  NoteBloc({required this.repository}) : super(NoteLoading()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<SortNotesEvent>(_onSortNotes);
    on<SearchNotesEvent>(
      _onSearchNotes,
      transformer: (events, mapper) =>
          events.debounceTime(const Duration(milliseconds: 300)).asyncExpand(mapper),
    );
    _setupChangeListener();
  }

  void _setupChangeListener() {
    if (repository is NoteRepositoryImpl) {
      final dataSource = (repository as NoteRepositoryImpl).dataSource;

      if (dataSource is IsarNoteDataSource) {
        _changeSubscription = dataSource.onChange.listen((_) => add(LoadNotesEvent()));
      }
    }
  }

  @override
  void onEvent(NoteEvent event) {
    super.onEvent(event);
    log('Event received: ${event.runtimeType} - $event', name: 'NoteBloc');
  }

  @override
  void onChange(Change<NoteState> change) {
    super.onChange(change);
    log(
      'State changed: ${change.nextState.runtimeType} - ${change.nextState}',
      name: 'NoteBloc',
    );
  }

  Future<void> _onLoadNotes(LoadNotesEvent event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final notes = await repository.getNotes();
      emit(NoteLoaded(notes: notes, filteredNotes: notes));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  Future<void> _onAddNote(AddNoteEvent event, Emitter<NoteState> emit) async {
    if (state is NoteLoaded) {
      final currentState = state as NoteLoaded;
      final optimisticNotes = [...currentState.notes, event.note];
      emit(NoteLoaded(notes: optimisticNotes, filteredNotes: optimisticNotes));
      try {
        await repository.addNote(event.note);
      } catch (e) {
        emit(NoteError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateNote(UpdateNoteEvent event, Emitter<NoteState> emit) async {
    if (state is NoteLoaded) {
      final currentState = state as NoteLoaded;
      final updatedNotes =
          currentState.notes.map((note) => note.id == event.note.id ? event.note : note).toList();

      emit(currentState.copyWith(notes: updatedNotes));
      try {
        await repository.updateNote(event.note);
      } catch (e) {
        emit(NoteError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteNote(DeleteNoteEvent event, Emitter<NoteState> emit) async {
    if (state is NoteLoaded) {
      final currentState = state as NoteLoaded;
      final updatedNotes = currentState.notes.where((note) => note.id != event.id).toList();
      emit(currentState.copyWith(notes: updatedNotes));
      try {
        await repository.deleteNote(event.id);
      } catch (e) {
        emit(NoteError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onSearchNotes(SearchNotesEvent event, Emitter<NoteState> emit) {
    if (state is NoteLoaded) {
      final currentState = state as NoteLoaded;
      final filteredNotes = event.query.isEmpty
          ? <NoteEntity>[]
          : currentState.notes
              .where((note) =>
                  note.title.toLowerCase().contains(event.query.toLowerCase()) ||
                  note.content.toLowerCase().contains(event.query.toLowerCase()))
              .toList();
      ;
      emit(currentState.copyWith(filteredNotes: filteredNotes));
    }
  }

  void _onSortNotes(SortNotesEvent event, Emitter<NoteState> emit) {
    if (state is NoteLoaded) {
      final currentState = state as NoteLoaded;
      final sortedNotes = List<NoteEntity>.from(currentState.notes)
        ..sort((a, b) => event.ascending
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt));
      emit(currentState.copyWith(notes: sortedNotes));
    }
  }

  @override
  Future<void> close() {
    _changeSubscription.cancel();
    return super.close();
  }
}
