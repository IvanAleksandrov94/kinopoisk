import 'package:chopper/chopper.dart';
import 'package:dbproject/data/BuiltValueConverter.dart';
import 'package:dbproject/models/Kinopoisk.dart';

part 'ApiService.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService {
  @Get(path: 'https://api.kinopoisk.cloud/{type}/{id}/token/{token}')
  Future<Response<Kinopoisk>> getSingleUser(
      @Path('token') String token, @Path('id') String id, @Path('type') String type);

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
