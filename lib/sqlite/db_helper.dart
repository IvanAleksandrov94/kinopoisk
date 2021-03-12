import 'dart:async';
import 'package:dbproject/models/Kinopoisk.dart';
import 'package:dbproject/repository/db_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  Database _database;
  String dbKinopoisk = 'kinopoiskMovies.db';
  // String dbNameSerials = 'kinopoisSerials.db';
  String tableMovies = 'kinopoiskMovies';
  String tableSerials = 'kinopoiskSerials';

  // Открытие DB
  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), dbKinopoisk), version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE $tableMovies (id INTEGER PRIMARY KEY AUTOINCREMENT, movieId INTEGER, name TEXT, title TEXT, year INTEGER,poster TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE $tableSerials (id INTEGER PRIMARY KEY AUTOINCREMENT, movieId INTEGER, name TEXT, title TEXT, year INTEGER,poster TEXT, description TEXT)");
      });
    }
  }

  //Удаление DB
  Future deleteTable() async {
    await _database.execute('DELETE FROM $tableMovies');
  }

// Обновление DB
  Future updateFromById(
      int id, String name, String title, int year, String poster, String description) async {
    await _database.execute(
        "UPDATE $tableMovies SET id = '$id', name = '$name', title = '$title', year = '$year', poster = '$poster', description = '$description'  WHERE id = $id");
  }

  // Добавление в DB
  Future insertMovie(Movie movie) async {
    await openDb();
    // await _database.execute(
    //     "INSERT INTO $tableMovies(name, movieId, title, year, poster, description) VALUES('${movie.name}', '${movie.movieId}', '${movie.title}', ${movie.year}, '${movie.poster}', '${movie.description}')");
    return await _database.insert(tableMovies, movie.toMap());
  }

  //Получение DB
  Future<List<Movie>> getMoviesList() async {
    await openDb();
    List<Map<String, dynamic>> maps = await _database.query(tableMovies);
    return List.generate(maps.length, (i) {
      return Movie(
          id: maps[i]['id'],
          movieId: maps[i]['movieId'],
          name: maps[i]['name'],
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
