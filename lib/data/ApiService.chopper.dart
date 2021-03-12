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
  Future<Response<Kinopoisk>> getSingleUser(
      String token, String id, String type) {
    final $url = 'https://api.kinopoisk.cloud/$type/$id/token/$token';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<Kinopoisk, Kinopoisk>($request);
  }
}
