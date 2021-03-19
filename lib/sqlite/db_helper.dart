import 'dart:async';
import 'package:dbproject/repository/db_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  Database _database;
  static const String dbKinopoisk = 'kinopoisk.db';
  static const String tableMovies = 'kinopoiskMovies';
  static const String tableSerials = 'kinopoiskSerials';
  static const String tablePicture = 'kinopoiskPicture';
  static const String tableFavorites = 'kinopoiskFavorites';
  static const String tableCinema = 'cinema';
  static const String tablePrices = 'prices';

  //https://cdn4.iconfinder.com/data/icons/ionicons/512/icon-close-512.png

  // Открытие DB
  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), dbKinopoisk), version: 1,
          onCreate: (Database db, int version) async {
        await db.execute("""CREATE TABLE $tableMovies (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              type TEXT,
              title TEXT,
              year INTEGER,
              poster TEXT,
              description TEXT)""");
        await db.execute("""CREATE TABLE $tableSerials (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT, type TEXT,
              title TEXT,
              year INTEGER,
              poster TEXT,
              description TEXT)""");
        await db.execute("""CREATE TABLE $tablePicture (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              poster TEXT,
              description TEXT)""");
        await db.execute("""CREATE TABLE $tableFavorites (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              customer INTEGER,
              name TEXT,
              type TEXT,
              title TEXT,
              year INTEGER,
              poster TEXT,
              description TEXT)""");
      });
    } else {
      _database = await openDb();
      return _database;
    }
  }

  Future<bool> open() async {
    _database = await openDatabase(dbKinopoisk);
    return true;
  }


  //Удаление DB
  Future deleteTable(String db, int id) async {
    await open();
    await _database.execute("DELETE FROM $db WHERE id = '$id'");
  }

// Обновление DB
  Future updateFromById(String db, int id, String name, String type, String title, int year,
      String poster, String description) async {
    await open();
    await _database.execute(
        "UPDATE $db SET id = '$id', name = '$name', type = '$type', title = '$title', year = '$year', poster = '$poster', description = '$description'  WHERE id = $id");
  }

  // Обновление DB favorits
  Future updateFromByIdFavorits(String db, Movie movie) async {
    await open();
    await _database.execute(
        "UPDATE $db SET id = '${movie.id}', customer = ${movie.customer}, name = '${movie.name}', type = '${movie.type}', title = '${movie.title}', year = '${movie.year}', poster = '${movie.poster}', description = '${movie.description}'  WHERE id = ${movie.id}");
  }

  // Добавление в DB Фильма
  Future insertData(String db, Movie movie) async {
    await open();
    await _database.execute("""INSERT INTO $db(
        name,
        type,
        title,
        year,
        poster,
        description)
        VALUES('${movie.name}',
        '${movie.type}',
        '${movie.title}',
        ${movie.year},
        '${movie.poster}',
        '${movie.description}')""");
  }

// Добавление в избранные
  Future insertDataFavorites(String db, Movie movie) async {
    await open();
    await _database.execute(
        "INSERT INTO $db(customer, name, type, title, year, poster, description) VALUES(${movie.customer}, '${movie.name}', '${movie.type}', '${movie.title}',  ${movie.year}, '${movie.poster}', '${movie.description}')");
  }

  // На груповую операцию по увеличению года
  Future<List<Map<String, dynamic>>> groupBy(String db) async {
    await open();
    print('START');
    return await _database.rawQuery("""
           SELECT kinopoiskFavorites.name, kinopoiskFavorites.year, COUNT(*) 'кол-во' 
           FROM $tableFavorites
           INNER JOIN $tableMovies
           ON  kinopoiskMovies.id = kinopoiskFavorites.customer 
           INNER JOIN $tableSerials
           ON  kinopoiskSerials.id = kinopoiskFavorites.customer 
           GROUP BY kinopoiskFavorites.name
           """);
  }

  //Перекресный запрос на сумму фильмов определеннго года
  Future<List<Map<String, dynamic>>> totalSum(String db, int yearCount) async {
    await open();
    return await _database
        .rawQuery("SELECT SUM(case when year = $yearCount then 1 end) as Count FROM $db");
  }

  // Параметрический
  Future<List<Movie>> selectYear({String db, int countYearMax, int countYearMin}) async {
    await open();
    List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT id, name, type, title, year, poster, description FROM $db WHERE year < $countYearMax AND year > $countYearMin');
    return List.generate(maps.length, (i) {
      return Movie(
          id: maps[i]['id'],
          name: maps[i]['name'],
          type: maps[i]['type'],
          title: maps[i]['title'],
          year: maps[i]['year'],
          poster: maps[i]['poster'],
          description: maps[i]['description']);
    });
  }

  // Выборка movie or tv-series
  Future<List<Movie>> selectType(String db, String type) async {
    List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT id, name, type, title, year, poster, description FROM $db WHERE type = "$type"');
    return List.generate(maps.length, (i) {
      return Movie(
          id: maps[i]['id'],
          name: maps[i]['name'],
          type: maps[i]['type'],
          title: maps[i]['title'],
          year: maps[i]['year'],
          poster: maps[i]['poster'],
          description: maps[i]['description']);
    });
  }

  //Получение DB
  Future<List<Movie>> getData(String db) async {
    await open();
    List<Map<String, dynamic>> maps = await _database.rawQuery('SELECT * FROM $db');
    return List.generate(maps.length, (i) {
      return Movie(
          id: maps[i]['id'],
          customer: maps[i]['customer'],
          name: maps[i]['name'],
          type: maps[i]['type'],
          title: maps[i]['title'],
          year: maps[i]['year'],
          poster: maps[i]['poster'],
          description: maps[i]['description']);
    });
  }

  // Закрытие DB
  Future closeDB() async {
    _database.close();
  }
}
