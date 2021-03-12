import 'dart:async';
import 'package:dbproject/repository/db_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  Database _database;
  static const String dbKinopoisk = 'kinopoisk.db';
  static const String tableMovies = 'kinopoiskMovies';
  static const String tableSerials = 'kinopoiskSerials';
  static const String tableFavorites = 'kinopoiskFavorites';
  static const String tableCinema = 'cinema';
  static const String tablePrices = 'prices';

  // Открытие DB
  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), dbKinopoisk), version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE $tableMovies (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT, title TEXT, year INTEGER,poster TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE $tableSerials (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT, title TEXT, year INTEGER,poster TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE $tableFavorites (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT, title TEXT, year INTEGER,poster TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE $tableCinema (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, places INTEGER)");
        await db.execute(
            "CREATE TABLE $tablePrices (id INTEGER PRIMARY KEY AUTOINCREMENT, prices INTEGER)");
      });
    }
  }

  Future autoInsertCinemaAndPrice() async {
    await _database.execute("INSERT INTO $tableCinema(name, places) VALUES('Синема 5', '300')");
    await _database.rawInsert("INSERT INTO $tableCinema(name, places) VALUES('Мир Люксор', 500)");
    await _database.rawInsert("INSERT INTO $tableCinema(name, places) VALUES('Три пингвина', 700)");
    await _database.rawInsert("INSERT INTO $tableCinema(name, places) VALUES('Волжский', 350)");
    await _database.rawInsert("INSERT INTO $tablePrices(prices) VALUES(250)");
    await _database.rawInsert("INSERT INTO $tablePrices(prices) VALUES(300)");
    await _database.rawInsert("INSERT INTO $tablePrices(prices) VALUES(150)");
  }

  //Удаление DB
  Future deleteTable(String db, int id) async {
    await _database.execute("DELETE FROM $db WHERE id = '$id'");
  }

// Обновление DB
  Future updateFromById(String db, int id, String name, String type, String title, int year,
      String poster, String description) async {
    await _database.execute(
        "UPDATE $db SET id = '$id', name = '$name', type = '$type', title = '$title', year = '$year', poster = '$poster', description = '$description'  WHERE id = $id");
  }

  // Добавление в DB Фильма
  Future insertData(String db, Movie movie) async {
    await _database.execute(
        "INSERT INTO $db(name, type, title, year, poster, description) VALUES('${movie.name}', '${movie.type}', '${movie.title}',  ${movie.year}, '${movie.poster}', '${movie.description}')");
  }

  // На груповую операцию по увеличению года
  Future<List<Map<String, dynamic>>> groupBy(String db) async {
    print('START');
     return await _database.rawQuery("""
           SELECT kinopoiskSerials.year, kinopoiskMovies.year, kinopoiskSerials.name, kinopoiskSerials.type
           FROM $tableSerials
           JOIN $tableMovies
           ON  kinopoiskMovies.id + kinopoiskSerials.id
           ORDER BY kinopoiskMovies.year
           """);
  }

  //Перекресный запрос на сумму фильмов определеннго года
  Future<List<Map<String, dynamic>>> totalSum(String db, int yearCount) async {
    return await _database
        .rawQuery("SELECT SUM(case when year = $yearCount then 1 end) as Count FROM $db");
  }

  // Выборка по году count
  Future<List<Movie>> selectYear({String db, int countYearMax, int countYearMin}) async {
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

  // Выборка по типу movie or tv-series
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
    List<Map<String, dynamic>> maps = await _database.rawQuery('SELECT * FROM $db');
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

  // Закрытие DB
  Future closeDB() async {
    _database.close();
  }
}
