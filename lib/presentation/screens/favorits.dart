import 'package:flutter/material.dart';
import 'package:dbproject/repository/db_repository.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../sqlite/db_helper.dart';

class FavoritsScreen extends StatefulWidget {
  FavoritsScreen({Key key}) : super(key: key);

  @override
  _FavoritsScreenState createState() => _FavoritsScreenState();
}

class _FavoritsScreenState extends State<FavoritsScreen> {
  var dbManager = DbManager();
  bool isLoad = false;
  SlidableController _slidableController;
  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorits"),
      ),
      body: FutureBuilder(
          future: dbManager.getData(DbManager.tableFavorites),
          builder: (context, snapshot) {
            List<Movie> data = snapshot.data;
            if (snapshot.hasData) {
              print(data[6].toMap());

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return Slidable(
                      actionExtentRatio: 0.25,
                      controller: _slidableController,
                      actionPane: SlidableDrawerActionPane(),
                      actions: [
                        SlideAction(
                          color: data[i].customer == 1 ? Colors.green[500] : Colors.redAccent[100],
                          onTap: () {
                            print(data[i].toMap());
                            dbManager.updateFromByIdFavorits(
                                DbManager.tableFavorites,
                                Movie(
                                    id: data[i].id,
                                    customer: data[i].customer == 1 ? 2 : 1,
                                    name: data[i].title,
                                    type: data[i].type,
                                    title: data[i].title,
                                    year: data[i].year,
                                    poster: data[i].poster,
                                    description: data[i].description));
                            setState(() {});
                          },
                          child: data[i].customer == 1 ? Text('add viewed') : Text("remove view"),
                        ),
                      ],
                      secondaryActions: [
                        SlideAction(
                          color: Colors.red,
                          onTap: () async {
                            dbManager.deleteTable(DbManager.tableFavorites, i + 1);
                            setState(() {});
                          },
                          child: Text('Delete'),
                        ),
                      ],
                      child: ListTile(
                        tileColor: data[i].customer == 2
                            ? Colors.green.withOpacity(0.4)
                            : Colors.green.withOpacity(0),
                        leading: data[i].poster != 'null' && data[i].poster != 'poster'
                            ? Image.network("https:" + data[i].poster)
                            : const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 40.0,
                              ),
                        subtitle: Text(data[i].year.toString() + " год"),
                        trailing: Column(
                          children: [
                            Text(data[i].type),
                          ],
                        ),
                        title: Text(data[i].name),
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
