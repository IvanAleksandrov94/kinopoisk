// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiService.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$ApiService extends ApiService {
  _$ApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiService;

  @override
  Future<Response<Kinopoisk>> getSingleUser(String id) {
    final $url = 'https://api.kinopoisk.cloud/movies/1143242/token/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<Kinopoisk, Kinopoisk>($request);
  }
}
