import 'package:dio/dio.dart';

import '../utils/constants.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );


  }

  static final ApiClient _instance = ApiClient._internal();

  late final Dio _dio;

  static Dio get dio => _instance._dio;
}

