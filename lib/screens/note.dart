import 'package:demo/blocs/notes/notes_bloc.dart';
import 'package:demo/blocs/notes/notes_event.dart';
import 'package:demo/blocs/notes/notes_state.dart';
import 'package:demo/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, this.note, required this.title, this.date}) : super(key: key);

  final String title;

  final Note? note;

  final String? date;

  @override
  State<NoteScreen> createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  late TextEditingController _controller;
  String description = '';
  bool isEdit = false;

  @override
  initState() {
    super.initState();
    isEdit = widget.note != null ? true : false;
    description = widget.note?.description ?? '';
    _controller = TextEditingController(text: description);
  }

  bool isValid() {
    return description != '' && description != widget.note?.description;
  }

  @override
  Widget build(BuildContext context) {
    print("is edit $isEdit");
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            BlocBuilder<NotesBloc, NotesState>(
                builder: (_context, _) {
                  return TextButton(
                    onPressed: () {
                      if (widget.date != null && description != '') {
                        if (isEdit) {
                          _context.read<NotesBloc>().add(UpdateNote(
                              Note(widget.date as String, description, id: widget.note?.id)
                          ));
                        } else {
                          _context.read<NotesBloc>().add(AddNote(
                              Note(widget.date as String, description)
                          ));
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(isEdit ? 'Save' : 'Create', style: TextStyle(fontSize: 17, color: isValid() ? Colors.lightBlue : Colors.grey )),
                  );
                }
            ),
            isEdit ? BlocBuilder<NotesBloc, NotesState>(
                builder: (_context, _) {
                  return TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _context.read<NotesBloc>().add(DeleteNote(widget.note as Note));
                    },
                    child: Text('Delete', style: TextStyle(fontSize: 17, color:  Colors.redAccent )),
                  );
                }
            ) : Container(),
          ],
          leading: const BackButton(
              color: Colors.black
          ),
          backgroundColor: Colors.white,
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0,
          bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
            preferredSize: const Size.fromHeight(0.5),
          ),
        ),
        body: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, state) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xffFAFAFA),
                ),
                child: Column(
                  children: [
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        maxLines: 8,
                        autofocus: true,
                        maxLength: 300,
                        controller: _controller,
                        onChanged: (String text) {
                          print(isValid());
                          setState(() {
                            description = text;
                          });
                        },
                        decoration: const InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter todo note',
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
        )
    );
  }
}