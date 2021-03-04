import 'package:built_collection/built_collection.dart';
import 'package:chopper/chopper.dart';
import 'package:dbproject/data/BuiltValueConverter.dart';
import 'package:dbproject/models/Kinopoisk.dart';

part 'ApiService.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService {
  @Get(path: '/movies/all/page/666/token/{id}')
  Future<Response<Kinopoisk>> getSingleUser(@Path('id') String id);

  static ApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://api.kinopoisk.cloud',
      services: [_$ApiService()],
      converter: BuiltValueConverter(),
      errorConverter: BuiltValueConverter(),
    );
    return _$ApiService(client);
  }
}
