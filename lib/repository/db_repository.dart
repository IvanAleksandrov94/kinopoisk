import 'package:flutter/foundation.dart';

class Movie {
  final int id;
  final String name;
  final String type;
  final String title;
  final int year;
  final String poster;
  final String description;

  Movie({
    @required this.name,
    
    @required this.type,
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
      'type': type,
      'title': title,
      'year': year,
      'poster': poster,
      'description': description,
    };
  }
}
