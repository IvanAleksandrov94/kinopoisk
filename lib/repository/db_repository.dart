import 'package:flutter/foundation.dart';

class Movie {
  final int id;
  final String name;
  final int movieId;
  final String title;
  final int year;
  final String poster;
  final String description;

  Movie({
    @required this.name,
    @required this.movieId,
    this.id,
    this.title,
    this.year,
    this.poster,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'movieId': movieId,
      'title': title,
      'year': year,
      'poster': poster,
      'description': description,
    };
  }
}
