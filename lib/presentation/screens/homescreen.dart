import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chopper/chopper.dart';
import 'package:dbproject/blocs/kinopoisk_bloc/kinopoisk_bloc.dart';
import 'package:dbproject/data/ApiService.dart';
import 'package:dbproject/models/Kinopoisk.dart';
import 'package:dbproject/presentation/screens/favorits.dart';
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
    dbManager = DbManager()..open();
    activeDB = DbManager.tableMovies;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: activeDB != null
                  ? dbManager.getData(
                      activeDB,
                    )
                  : dbManager.getData(
                      'kinopoiskMovies',
                    ),
              builder: (context, snapshot) {
                List<Movie> data = snapshot.data;
                if (snapshot.data != null) {
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
                          actionExtentRatio: 0.25,
                          controller: _slidableController,
                          actionPane: SlidableDrawerActionPane(),
                          actions: [
                            SlideAction(
                              color: Colors.green,
                              onTap: () {
                                dbManager.insertDataFavorites(
                                    DbManager.tableFavorites,
                                    Movie(
                                        customer: 1,
                                        name: data[index].title,
                                        type: data[index].type,
                                        title: data[index].title,
                                        year: data[index].year,
                                        poster: data[index].poster,
                                        description: data[index].description));
                                setState(() {});
                              },
                              child: Text('add favorits'),
                            ),
                          ],
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
                          child: Center(
                            child: ListTile(
                              leading: data[index].poster != null && data[index].poster.length != 0
                                  ? Image.network("https:" + data[index].poster)
                                  : const Icon(Icons.close),
                              subtitle: Text(data[index].year.toString() + " год"),
                              trailing: Column(
                                children: [
                                  Text(data[index].id.toString()),
                                  Text(data[index].type),
                                ],
                              ),
                              title: Text(data[index].name),
                            ),
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
                    'f3b1257ca5aed91693957832ac3153c8', '77044', 'tv-series');
                movies.then((value) {
                  kinopoisk = value.body;
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
                Random rnd;
                int min = 1110;
                int max = 1500;
                rnd = Random();
                int val = min + rnd.nextInt(max - min);
                print(val);

                var movies =
                    apiService.getSingleUser('f3b1257ca5aed91693957832ac3153c8', '$val', 'movies');
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
                var res =
                    await showTextInputDialog(context: context, message: "update", textFields: [
                  DialogTextField(
                    hintText: 'min',
                  ),
                  DialogTextField(
                    hintText: 'max',
                  ),
                ]);
                if (res != null) {
                  var a = [];
                  dbManager
                      .selectYear(
                          db: activeDB,
                          countYearMax: int.parse(res[1]),
                          countYearMin: int.parse(res[0]))
                      .then((value) {
                    value.forEach((element) {
                      a.add(element.toMap());
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => SimpleDialog(
                            title: Center(child: Text("параматрический")),
                            children: a
                                .map<Widget>((e) => Container(
                                    height: 50,
                                    child: SingleChildScrollView(
                                        child: SizedBox(height: 50, child: Text(e.toString())))))
                                .toList()));
                  });
                  setState(() {});
                }
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
                 Navigator.push(context, MaterialPageRoute(builder: (builder) => FavoritsScreen()));
                // List<String> a = [];

                // final res = await showOkCancelAlertDialog(
                //   context: context,
                //   title: 'Вывести избранное?',
                //   okLabel: 'Ok',
                //   cancelLabel: 'Cancel',
                // );

                // if (res == OkCancelResult.ok) {
                //   dbManager.getData(DbManager.tableFavorites).then((value) {
                //     value.forEach((element) {
                //       a.add(element.toMap().toString());

                //       print(a);

                //       print(element);
                //     });
                //   });
                // } else {}

                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) => SimpleDialog(
                //         title: Center(child: Text("resoult")),
                //         children: a
                //             .map<Widget>((e) => Container(
                //                 height: 50,
                //                 child: SingleChildScrollView(
                //                     child: Column(
                //                   children: [
                //                     SizedBox(height: 50, child: Text(e.toString())),
                //                   ],
                //                 ))))
                //             .toList()));
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: ElevatedButton(
                  onPressed: () async {
                    List<String> a = [];

                    final res = await showOkCancelAlertDialog(
                      context: context,
                      title: 'Выборка',
                      okLabel: 'Movie',
                      cancelLabel: 'Serial',
                    );

                    if (res == OkCancelResult.ok) {
                      dbManager.selectType(DbManager.tableFavorites, 'movie').then((value) {
                        value.forEach((element) {
                          a.add(element.toMap().toString());

                          print(a);

                          print(element);
                        });
                      });
                    } else {
                      dbManager.selectType(DbManager.tableFavorites, 'tv-series').then((value) {
                        value.forEach((element) {
                          a.add(element.toMap().toString());

                          print(a);

                          print(element);
                        });
                      });
                    }

                    showDialog(
                        context: context,
                        builder: (BuildContext context) => SimpleDialog(
                            title: Center(child: Text("resoult")),
                            children: a
                                .map<Widget>((e) => Container(
                                    height: 50,
                                    child: SingleChildScrollView(
                                        child: Column(
                                      children: [
                                        SizedBox(height: 50, child: Text(e.toString())),
                                      ],
                                    ))))
                                .toList()));
                  },
                  child: Text('выборка'),
                )),
              ],
            ),
            Center(
                child: ElevatedButton(
              onPressed: () async {
                //Map<String, dynamic> a = {};
                List<String> a = [];
                var res =
                    await showTextInputDialog(context: context, message: "update", textFields: [
                  DialogTextField(
                    hintText: 'year',
                  ),
                ]);
                if (res != null) {
                  dbManager.totalSum(activeDB, int.parse(res[0])).then((value) {
                    value.forEach((element) {
                      a.add(element.toString());

                      //print(element);
                    });
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => SimpleDialog(
                          title: Center(child: Text("Перекрестный")),
                          children: a
                              .map<Widget>((e) => Container(
                                  height: 50,
                                  child: SingleChildScrollView(
                                      child: SizedBox(height: 50, child: Text(e.toString())))))
                              .toList()));
                }
              },
              child: Text('перекрестный'),
            )),
          ],
        )
      ],
    );
  }
}
