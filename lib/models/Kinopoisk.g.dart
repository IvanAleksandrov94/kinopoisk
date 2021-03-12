// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Kinopoisk.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Kinopoisk> _$kinopoiskSerializer = new _$KinopoiskSerializer();

class _$KinopoiskSerializer implements StructuredSerializer<Kinopoisk> {
  @override
  final Iterable<Type> types = const [Kinopoisk, _$Kinopoisk];
  @override
  final String wireName = 'Kinopoisk';

  @override
  Iterable<Object> serialize(Serializers serializers, Kinopoisk object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
    ];
    if (object.year != null) {
      result
        ..add('year')
        ..add(serializers.serialize(object.year,
            specifiedType: const FullType(int)));
    }
    if (object.age != null) {
      result
        ..add('age')
        ..add(serializers.serialize(object.age,
            specifiedType: const FullType(String)));
    }
    if (object.poster != null) {
      result
        ..add('poster')
        ..add(serializers.serialize(object.poster,
            specifiedType: const FullType(String)));
    }
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.countries != null) {
      result
        ..add('countries')
        ..add(serializers.serialize(object.countries,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    if (object.actors != null) {
      result
        ..add('actors')
        ..add(serializers.serialize(object.actors,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    return result;
  }

  @override
  Kinopoisk deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new KinopoiskBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'year':
          result.year = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'age':
          result.age = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'poster':
          result.poster = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'countries':
          result.countries.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<dynamic>);
          break;
        case 'actors':
          result.actors.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$Kinopoisk extends Kinopoisk {
  @override
  final String type;
  @override
  final String title;
  @override
  final int year;
  @override
  final String age;
  @override
  final String poster;
  @override
  final String description;
  @override
  final BuiltList<String> countries;
  @override
  final BuiltList<String> actors;

  factory _$Kinopoisk([void Function(KinopoiskBuilder) updates]) =>
      (new KinopoiskBuilder()..update(updates)).build();

  _$Kinopoisk._(
      {this.type,
      this.title,
      this.year,
      this.age,
      this.poster,
      this.description,
      this.countries,
      this.actors})
      : super._() {
    if (type == null) {
      throw new BuiltValueNullFieldError('Kinopoisk', 'type');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Kinopoisk', 'title');
    }
  }

  @override
  Kinopoisk rebuild(void Function(KinopoiskBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KinopoiskBuilder toBuilder() => new KinopoiskBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Kinopoisk &&
        type == other.type &&
        title == other.title &&
        year == other.year &&
        age == other.age &&
        poster == other.poster &&
        description == other.description &&
        countries == other.countries &&
        actors == other.actors;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, type.hashCode), title.hashCode),
                            year.hashCode),
                        age.hashCode),
                    poster.hashCode),
                description.hashCode),
            countries.hashCode),
        actors.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Kinopoisk')
          ..add('type', type)
          ..add('title', title)
          ..add('year', year)
          ..add('age', age)
          ..add('poster', poster)
          ..add('description', description)
          ..add('countries', countries)
          ..add('actors', actors))
        .toString();
  }
}

class KinopoiskBuilder implements Builder<Kinopoisk, KinopoiskBuilder> {
  _$Kinopoisk _$v;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  int _year;
  int get year => _$this._year;
  set year(int year) => _$this._year = year;

  String _age;
  String get age => _$this._age;
  set age(String age) => _$this._age = age;

  String _poster;
  String get poster => _$this._poster;
  set poster(String poster) => _$this._poster = poster;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  ListBuilder<String> _countries;
  ListBuilder<String> get countries =>
      _$this._countries ??= new ListBuilder<String>();
  set countries(ListBuilder<String> countries) => _$this._countries = countries;

  ListBuilder<String> _actors;
  ListBuilder<String> get actors =>
      _$this._actors ??= new ListBuilder<String>();
  set actors(ListBuilder<String> actors) => _$this._actors = actors;

  KinopoiskBuilder();

  KinopoiskBuilder get _$this {
    if (_$v != null) {
      _type = _$v.type;
      _title = _$v.title;
      _year = _$v.year;
      _age = _$v.age;
      _poster = _$v.poster;
      _description = _$v.description;
      _countries = _$v.countries?.toBuilder();
      _actors = _$v.actors?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Kinopoisk other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Kinopoisk;
  }

  @override
  void update(void Function(KinopoiskBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Kinopoisk build() {
    _$Kinopoisk _$result;
    try {
      _$result = _$v ??
          new _$Kinopoisk._(
              type: type,
              title: title,
              year: year,
              age: age,
              poster: poster,
              description: description,
              countries: _countries?.build(),
              actors: _actors?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'countries';
        _countries?.build();
        _$failedField = 'actors';
        _actors?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Kinopoisk', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
