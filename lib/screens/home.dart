import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:demo/screens/noteList.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo/blocs/notes/notes_bloc.dart';
import 'package:demo/blocs/notes/notes_state.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool showDateWithNotes = false;
  List<DateTime> items = [];

  @override
  initState() {
    super.initState();
    items = generateDates();
  }

  List<DateTime> generateDates([DateTime? date]) {
    DateTime _date = date ?? DateTime.now();

    return List<DateTime>.generate(
        40,
        (i) => DateTime.utc(
              _date.year,
              _date.month,
              _date.day,
            ).subtract(Duration(days: i)));
  }

  Future<bool> _loadMore() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 100));
    load();
    return true;
  }

  void load() {
    final DateTime lastElement = items[items.length - 1];
    final List<DateTime> newInterval = generateDates(lastElement);

    final List<DateTime> updated = List.from(items)..addAll(newInterval);

    setState(() {
      items = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: showDateWithNotes
                ? const Icon(Icons.star, size: 28)
                : const Icon(Icons.star_outline, size: 28),
            color: Colors.black,
            onPressed: () {
              setState(() {
                showDateWithNotes = !showDateWithNotes;
              });
            },
          )
        ],
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
                Expanded(
                    child: LazyLoadScrollView(
                  onEndOfPage: _loadMore,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4),
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final String date =
                          DateFormat('yyyy/MM/dd').format(items[index]);

                      final notesCount = state.getGrouped()[date] != null
                          ? state.getGrouped()[date]?.length
                          : 0;
                      bool showOnlyWithDates = showDateWithNotes
                          ? notesCount! > 0
                          : !showDateWithNotes;

                      return showOnlyWithDates
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) =>
                                        NoteListScreen(title: date)));
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(
                                        color: notesCount! > 0
                                            ? const Color(0xff68CCFF)
                                            : const Color(0xffE8E8E8),
                                        width: 4)),
                                child: Column(
                                  children: [
                                    Stack(children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 92,
                                        child: Text(
                                          date,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      if (notesCount > 0)
                                        Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Text("$notesCount",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey))),
                                    ]),
                                  ],
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                              ),
                            )
                          : Container();
                    },
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
