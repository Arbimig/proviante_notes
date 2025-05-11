import 'package:equatable/equatable.dart';

import '../../domain/entities/note_entity.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<NoteEntity> notes;
  final List<NoteEntity> filteredNotes;

  const NoteLoaded({required this.notes, required this.filteredNotes});

  NoteLoaded copyWith({
    List<NoteEntity>? notes,
    List<NoteEntity>? filteredNotes,
  }) =>
      NoteLoaded(
        notes: notes ?? this.notes,
        filteredNotes: filteredNotes ?? this.filteredNotes,
      );
  @override
  List<Object?> get props => [notes, filteredNotes];
}

class NoteError extends NoteState {
  final String message;

  const NoteError({required this.message});

  @override
  List<Object?> get props => [message];
}
