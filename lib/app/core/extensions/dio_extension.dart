import 'package:dio/dio.dart';

import '../../data/api/api.dart';

extension DioCustomExtension on Dio {
  void setToken(String? token, {String? prefix}) {
    dio.options.headers['authorization'] =
        prefix == null ? 'Bearer $token' : '$prefix $token';
  }
}
