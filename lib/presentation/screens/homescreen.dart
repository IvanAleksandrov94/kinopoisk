import 'package:chopper/chopper.dart';
import 'package:dbproject/blocs/kinopoisk_bloc/kinopoisk_bloc.dart';
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
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  Kinopoisk kinopoisk;
                  var movies = apiService.getSingleUser(
                      '3d4a027b299fa38e7531549768ec8209', '77044', 'tv-series');
                  movies.then((value) {
                    kinopoisk = value.body;
                    // dbManager.openDb();
                    dbManager.insertData(
                        DbManager.tableSerials,
                        Movie(
                            name: kinopoisk.title,
                            type: kinopoisk.type,
                            title: kinopoisk.title,
                            year: kinopoisk.year,
                            poster: kinopoisk.poster,
                            description: 'kinopoisk.description'));
                  });

                  dbManager.getData(DbManager.tableSerials).then((value) {
                    print(value.length);
                    value.forEach((element) {
                      print(element.toMap());
                    });
                  });
                },
                child: Text('Get Serial'),
              )),
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  Kinopoisk kinopoisk;
                  var movies = apiService.getSingleUser(
                      '3d4a027b299fa38e7531549768ec8209', '1143242', 'movies');
                  movies.then((value) {
                    kinopoisk = value.body;
                    // dbManager.openDb();
                    dbManager.insertData(
                        DbManager.tableMovies,
                        Movie(
                            name: kinopoisk.title,
                            type: kinopoisk.type,
                            title: kinopoisk.title,
                            year: kinopoisk.year,
                            poster: kinopoisk.poster,
                            description: 'kinopoisk.description'));
                  });

                  dbManager.getData(DbManager.tableMovies).then((value) {
                    print(value.length);
                    value.forEach((element) {
                      print(element.toMap());
                    });
                  });
                },
                child: Text('Get Movie'),
              )),
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  dbManager.updateFromById(DbManager.tableMovies, 2, 'name', 'type', 'title', 1999,
                      'poster', 'description');
                },
                child: Text('update'),
              )),
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  dbManager
                      .selectYear(db: DbManager.tableMovies, countYearMax: 2000, countYearMin: 1900)
                      .then((value) {
                    value.forEach((element) {
                      print(element.toMap());
                    });
                  });
                },
                child: Text('выборка'),
              )),
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  dbManager.insertData(
                      DbManager.tablefavorites,
                      Movie(
                          name: 'kinopoisk.title',
                          type: 'kinopoisk.type',
                          title: 'kinopoisk.title',
                          year: 200,
                          poster: 'kinopoisk.posterr',
                          description: 'kinopoisk.description'));
                },
                child: Text('Добавить в избранное'),
              )),
              Center(
                  child: ElevatedButton(
                onPressed: () async {
                  // dbManager.getData(DbManager.tablefavorites).then((value) {
                  //   print(value.length);
                  //   value.forEach((element) {
                  //     print(element.toMap());
                  //   });
                  // });
                  dbManager
                      .totalSum(
                    DbManager.tablefavorites,
                  )
                      .then((value) {
                    print(value.length);
                    value.forEach((element) {
                      print(element);
                    });
                  });
                },
                child: Text('вывести избранное'),
              )),
            ],
          );
        } else
          return const SizedBox();
      },
    );
  }
}
