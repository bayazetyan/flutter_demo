import 'package:demo/blocs/notes/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:demo/screens/index.dart';

import 'blocs/app_bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(() => runApp(MyApp()), blocObserver: AppBlocObserver());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>(
          create: (BuildContext context) => NotesBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: const HomeScreen(title: 'Demo')
      ),
    );
  }
}
