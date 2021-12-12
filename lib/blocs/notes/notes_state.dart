import 'package:equatable/equatable.dart';
import 'package:demo/models/note.dart';

abstract class NotesState extends Equatable {
  final List<Note> notes;

  const NotesState([this.notes = const []]);

  @override
  List<Note> get props => [];

  Map<String, List<Note>>getGrouped () {
    Map<String, List<Note>> _group = {};

    for (var element in notes) {
      if (_group[element.date] != null) {
        _group[element.date]?.add(element);
      } else {
        _group[element.date] = [element];
      }
    }

    return _group;
  }

  List<Note> groupByDate(String date) {
    return getGrouped()[date] ?? [];
  }
}

class NotesUpdate extends NotesState {
  final List<Note> notes;

  const NotesUpdate(this.notes): super();

  @override
  List<Note> get props => notes;

  @override
  String toString() => 'Todo Added { Notes: $notes }';
}