import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dbproject/models/Kinopoisk.dart';

part 'serializers.g.dart';

@SerializersFor(const [Kinopoisk])
final Serializers serializers = _$serializers;

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
