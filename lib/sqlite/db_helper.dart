import 'dart:async';
import 'package:dbproject/repository/db_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  Database _database;
  static const String dbKinopoisk = 'kinopoisk.db';
  static const String tableMovies = 'kinopoiskMovies';
  static const String tableSerials = 'kinopoiskSerials';
  static const String tablefavorites = 'kinopoiskFavorites';

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
            "CREATE TABLE $tablefavorites (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT, title TEXT, year INTEGER,poster TEXT, description TEXT)");
      });
    }
  }

  //Удаление DB
  Future deleteTable(String db) async {
    await _database.execute('DELETE FROM $db');
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

  // На груповую операцию
  Future<List<Map<String, dynamic>>> groupBy(String db) async {
    return await _database.rawQuery("SELECT year, name FROM $db GROUP BY year");
  }
  //Перекресный запрос на сууму фильмов определеннго года
  Future<List<Map<String, dynamic>>> totalSum(String db) async {
    return await _database.rawQuery("SELECT sum(case when year = 200 then 1 end) as Count FROM $db");
    // return await _database.rawQuery("SELECT sum(case when year = 200 then year end) as CountFilms FROM $db");
  }

  // Выборка по году  count
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
