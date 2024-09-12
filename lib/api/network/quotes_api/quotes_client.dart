import 'package:dio/dio.dart';
import 'package:easy_book/utils/app_env.dart';

class QuotesApiClient {
  QuotesApiClient._();

  static final QuotesApiClient instance = QuotesApiClient._();

  static const Duration _connectTimeout = Duration(seconds: 25);
  static final AppEnv _appConfig = AppEnv.instance;

  Dio get dio => _dio;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _connectTimeout,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        'X-RapidAPI-Key': _appConfig.quoteApiKey,
        'X-RapidAPI-Host': _appConfig.quoteApiHost,
      },
      baseUrl: _appConfig.quoteBaseUrl,
    ),
  );
}
