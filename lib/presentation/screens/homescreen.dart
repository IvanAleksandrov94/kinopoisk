import 'package:chopper/chopper.dart';
import 'package:dbproject/blocs/kinopoisk_bloc/kinopoisk_bloc.dart';
//import 'package:dbproject/blocs/sql_bloc/bloc/sqlbloc_bloc.dart';
import 'package:dbproject/data/ApiService.dart';
import 'package:dbproject/models/Kinopoisk.dart';
import 'package:dbproject/repository/db_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../sqlite/db_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  KinopoiskBloc bloc;
  DbManager dbManager;
  final chopper = ChopperClient(services: [ApiService.create()]);
  ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService.create();
    bloc = BlocProvider.of<KinopoiskBloc>(context);
    dbManager = DbManager()..openDb();
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KinopoiskBloc, KinopoiskState>(
      builder: (context, state) {
        if (state is KinopoiskInitialState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(child: CupertinoActivityIndicator()),
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  Kinopoisk kinopoisk;

                  var movies = apiService.getSingleUser('3d4a027b299fa38e7531549768ec8209');
                  movies.then((value) {
                    kinopoisk = value.body;
                    // dbManager.openDb();
                    dbManager.insertMovie(Movie(
                        movieId: kinopoisk.id,
                        name: kinopoisk.title,
                        title: kinopoisk.title,
                        year: kinopoisk.year,
                        poster: kinopoisk.poster,
                        description: 'kinopoisk.description'));
                  });

                  dbManager.getMoviesList().then((value) {
                    print(value.length);
                    value.forEach((element) {
                      print(element.toMap());
                    });
                  });
                },
                child: Text('Click me'),
              )),
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  dbManager.updateFromById(2, 'name', 'title', 1999, 'poster', 'description');
                },
                child: Text('update'),
              )),
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  dbManager.deleteTable();
                },
                child: Text('delete'),
              )),
            ],
          );
        } else
          return const SizedBox();
      },
    );
  }
}
