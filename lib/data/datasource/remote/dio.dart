import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
Dio dio(Ref ref) {
  return Dio()..interceptors.add(CustomInterceptor());
}

class CustomInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Logger('REQUEST[${options.method}] => PATH: ${options.path}');

    if (options.headers['accessToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('accessToken');

      //실제 토큰으로 대체
      // final accessToken = await SecureStorage().read(key: STR_ACCESS_TOKEN_KEY);
      final accessToken = "token";
      options.headers.addAll({'authorization': 'Bearer $accessToken'});
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    Logger(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}
