import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'Kinopoisk.g.dart';

abstract class Kinopoisk implements Built<Kinopoisk, KinopoiskBuilder> {
  static Serializer<Kinopoisk> get serializer => _$kinopoiskSerializer;

  @BuiltValueField(wireName: 'movies')
  BuiltList<Movies> get movies;

  Kinopoisk._();

  factory Kinopoisk([void Function(KinopoiskBuilder) updates]) = _$Kinopoisk;
}

abstract class Movies implements Built<Movies, MoviesBuilder> {
  static Serializer<Movies> get serializer => _$moviesSerializer;

  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'type')
  String get type;
  @BuiltValueField(wireName: 'title')
  String get title;
  @nullable
  @BuiltValueField(wireName: 'year')
  int get year;
  @nullable
  @BuiltValueField(wireName: 'age')
  String get age;
  @nullable
  @BuiltValueField(wireName: 'poster')
  String get poster;
  @nullable
  @BuiltValueField(wireName: 'description')
  String get description;
  @nullable
  @BuiltValueField(wireName: 'countries')
  BuiltList<String> get countries;
  @nullable
  @BuiltValueField(wireName: 'actors')
  BuiltList<String> get actors;


  Movies._();

  factory Movies([void Function(MoviesBuilder) updates]) = _$Movies;
}


