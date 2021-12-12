import 'package:equatable/equatable.dart';
import 'package:demo/models/note.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Note> get props => [];
}

class AddNote extends NotesEvent {
  final Note note;

  const AddNote(this.note);

  @override
  List<Note> get props => [note];

  @override
  String toString() => 'TodoAdded { todo: $note }';
}

class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote(this.note);

  @override
  List<Note> get props => [note];

  @override
  String toString() => 'TodoUpdated { updatedTodo: $note }';
}

class DeleteNote extends NotesEvent {
  final Note note;

  const DeleteNote(this.note);

  @override
  List<Note> get props => [note];

  @override
  String toString() => 'TodoDeleted { todo: $note }';
}