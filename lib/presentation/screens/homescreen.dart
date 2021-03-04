import 'package:chopper/chopper.dart';
import 'package:dbproject/blocs/kinopoisk_bloc/kinopoisk_bloc.dart';
import 'package:dbproject/blocs/sql_bloc/bloc/sqlbloc_bloc.dart';
import 'package:dbproject/data/ApiService.dart';
import 'package:dbproject/models/Kinopoisk.dart';
import 'package:dbproject/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final chopper = ChopperClient(services: [ApiService.create()]);

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<KinopoiskBloc>(context);
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
              Center(child: RaisedButton(onPressed: () async {
                final Response<Kinopoisk> user =
            await ApiService.create().getSingleUser('43fa5ce9ddbc87d7fe45343546e9ddf2');
                 print(user.body.movies.first);
              }))
            ],
          );
        } else
          return Container(
            child: Text(''),
          );
      },
    );
  }
}
