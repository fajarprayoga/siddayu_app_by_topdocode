library api;

import 'package:dio/dio.dart';

part 'auth_api.dart';

BaseOptions dioOptions({String? baseUrl}) => BaseOptions(
    followRedirects: false,
    baseUrl: 'https://dummyjson.com/',
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 200),
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    responseType: ResponseType.plain,
    validateStatus: (status) => status! <= 598);

Dio dio = Dio(dioOptions());

mixin UseApi {
  AuthApi authApi = AuthApi();
}
