import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo/blocs/notes/index.dart';
import 'package:demo/models/note.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesUpdate([])) {
    on<AddNote>(onNoteAdd);
    on<UpdateNote>(onNoteUpdate);
    on<DeleteNote>(onNoteDelete);
  }

  void onNoteUpdate(UpdateNote event, emit) {
    final List<Note> updated =
    (state as NotesUpdate).notes.map((_note) {
      return _note.id == event.note.id ? event.note : _note;
    }).toList();
    emit(NotesUpdate(updated));
  }
  void  onNoteAdd(AddNote event, emit) {
    final List<Note> updated =
    List.from((state as NotesUpdate).notes)..add(event.note);
    emit(NotesUpdate(updated));
  }

  void  onNoteDelete(DeleteNote event, emit) {
    final List<Note> updated = (state as NotesUpdate)
        .notes
        .where((note) => note.id != event.note.id)
        .toList();
    emit(NotesUpdate(updated));
  }
}