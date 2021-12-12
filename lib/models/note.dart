import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Note extends Equatable  {
  final String id;
  final String date;
  final String description;

  Note(this.date, this.description, { String? id })
      : this.id = id ?? const Uuid().v1();

  Note copyWith({String? description, String? date, String? id}) {
    return Note(
        date ?? this.date,
        description ?? this.description,
        id: id ?? this.id
    );
  }

  @override
  List<Object> get props => [id, date, description];
}