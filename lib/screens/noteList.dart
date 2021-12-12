import 'package:demo/blocs/notes/notes_bloc.dart';
import 'package:demo/blocs/notes/notes_state.dart';
import 'package:demo/models/note.dart';
import 'package:demo/screens/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NoteListScreen> createState() => NoteListScreenState();
}

class NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.create),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        NoteScreen(title: 'Create Note', date: widget.title)));
              },
            ),
          ],
          leading: const BackButton(color: Colors.black),
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
        body: BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
          List<Note> notes = state.groupByDate(widget.title);

          return notes.isNotEmpty
              ? Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffFAFAFA),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.only(top: 4),
                                itemCount: notes.length,
                                itemBuilder: (_, index) {
                                  var item = notes[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => NoteScreen(
                                                  title: 'Edit Note',
                                                  note: item,
                                                  date: widget.title)));
                                    },
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minHeight: 100,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.amber[100],
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0,
                                                  0.5), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.description,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                    ),
                                  );
                                }))
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffFAFAFA),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('You have not any notes',
                            style: const TextStyle(fontSize: 18)),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => NoteScreen(
                                      title: 'Create Note',
                                      date: widget.title)));
                            },
                            child: const Text('CREATE NOTE'))
                      ],
                    ),
                  ),
                );
        }));
  }
}
