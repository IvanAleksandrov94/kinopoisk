import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chopper/chopper.dart';
import 'package:dbproject/blocs/kinopoisk_bloc/kinopoisk_bloc.dart';
import 'package:dbproject/data/ApiService.dart';
import 'package:dbproject/models/Kinopoisk.dart';
import 'package:dbproject/repository/db_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  Kinopoisk kinopoisk;
  SlidableController _slidableController;
  var activeDB;
  var command = 'OPEN';

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController();
    apiService = ApiService.create();
    bloc = BlocProvider.of<KinopoiskBloc>(context);
    dbManager = DbManager()..openDb();
    String activeDB = DbManager.tableMovies;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: FutureBuilder(
              future: dbManager.getData(
                activeDB,
              ),
              builder: (context, snapshot) {
                List<Movie> data = snapshot.data;
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var res = await showTextInputDialog(
                              context: context,
                              message: "update",
                              textFields: [
                                DialogTextField(hintText: 'name', initialText: data[index].name),
                                DialogTextField(hintText: 'type', initialText: data[index].type),
                                DialogTextField(
                                    hintText: 'year', initialText: data[index].year.toString()),
                              ]);
                          if (res != null) {
                            dbManager.updateFromById(activeDB, index + 1, res[0], res[1], 'title',
                                int.parse(res[2]), 'poster', 'description');
                            setState(() {});
                          }
                        },
                        child: Slidable(
                          controller: _slidableController,
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.2,
                          showAllActionsThreshold: 0.1,
                          secondaryActions: [
                            SlideAction(
                              color: Colors.red,
                              onTap: () async {
                                dbManager.deleteTable(activeDB, index + 1);
                                setState(() {});
                              },
                              child: Text('Delete'),
                            ),
                          ],
                          child: Column(
                            children: [
                              Text(data[index].id.toString()),
                              Text(data[index].name),
                              Text(
                                data[index].type,
                              ),
                              Text(data[index].year.toString())
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: ElevatedButton(
              onPressed: () async {
                activeDB = DbManager.tableSerials;
                var movies = apiService.getSingleUser(
                    '3d4a027b299fa38e7531549768ec8209', '77044', 'tv-series');
                movies.then((value) {
                  kinopoisk = value.body;
                  dbManager.openDb();
                  dbManager.insertData(
                      activeDB,
                      Movie(
                          name: kinopoisk.title,
                          type: kinopoisk.type,
                          title: kinopoisk.title,
                          year: kinopoisk.year,
                          poster: kinopoisk.poster,
                          description: kinopoisk.description));
                });

                dbManager.getData(DbManager.tableSerials).then((value) {
                  print(value.length);
                  value.forEach((element) {
                    print(element.toMap());
                  });
                });
                setState(() {});
              },
              child: Text('Get Serial'),
            )),
            Center(
                child: ElevatedButton(
              onPressed: () async {
                activeDB = DbManager.tableMovies;

                var movies = apiService.getSingleUser(
                    '3d4a027b299fa38e7531549768ec8209', '1143243', 'movies');
                movies.then((value) {
                  kinopoisk = value.body;
                  // dbManager.openDb();
                  dbManager.insertData(
                      activeDB,
                      Movie(
                          name: kinopoisk.title,
                          type: kinopoisk.type,
                          title: kinopoisk.title,
                          year: kinopoisk.year,
                          poster: kinopoisk.poster,
                          description: kinopoisk.description));
                });
                setState(() {});

                dbManager.getData(activeDB).then((value) {
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
              onPressed: () async {},
              child: Text('update'),
            )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: ElevatedButton(
              onPressed: () async {
                dbManager.insertData(
                    activeDB,
                    Movie(
                        name: 'kinopoisk.title',
                        type: 'kinopoisk.type',
                        title: 'kinopoisk.title',
                        year: 100,
                        poster: 'kinopoisk.posterr',
                        description: 'kinopoisk.description'));
              },
              child: Text('Добавить в избранное'),
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
              child: Text('Параметрический'),
            )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: ElevatedButton(
              onPressed: () async {
                dbManager
                    .getData(
                  DbManager.tableFavorites,
                )
                    .then((value) {
                  print(value.length);
                  value.forEach((element) {
                    print(element.toMap());
                  });
                });
              },
              child: Text('вывести избранное'),
            )),
            Center(
                child: ElevatedButton(
              onPressed: () async {
                //Map<String, dynamic> a = {};
                List<String> a = [];
                dbManager
                    .groupBy(
                  DbManager.tableFavorites,
                )
                    .then((value) {
                  value.forEach((element) {
                    a.add(element.toString());

                    print(a);

                    //print(element);
                  });
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                        title: Center(child: Text("INNER JOIN serials and movies")),
                        children: a
                            .map<Widget>((e) => Container(
                                height: 50,
                                child: SingleChildScrollView(
                                    child: SizedBox(height: 50, child: Text(e.toString())))))
                            .toList()));
              },
              child: Text('На групировку'),
            )),
          ],
        )
      ],
    );
  }
}
