import 'package:dbproject/blocs/kinopoisk_bloc/kinopoisk_bloc.dart';
import 'package:dbproject/blocs/sql_bloc/sqlbloc_bloc.dart';
import 'package:dbproject/presentation/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sqlite/db_helper.dart';

void main() {
  runApp(MyApp());
  DbManager().openDb();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      themeMode: ThemeMode.dark,
      home: MultiBlocProvider(providers: [
        BlocProvider<KinopoiskBloc>(
          create: (BuildContext context) => KinopoiskBloc(),
        ),
        BlocProvider<SqlBloc>(
          create: (BuildContext context) => SqlBloc()..add(SqlIninialEvent()),
        ),
      ], child: HomeScreen()),
    );
  }
}
