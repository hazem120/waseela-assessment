import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/constants.dart';

class BnplRepository {
  BnplRepository({Dio? dio, Logger? logger})
      : _dio = dio ?? ApiClient.dio,
        _logger = logger ?? Logger();

  final Dio _dio;
  final Logger _logger;

  /// GET /api/products — returns list of product maps or null on error.
  Future<List<Map<String, dynamic>>?> getProducts() async {
    const endpoint = AppConstants.productsEndpoint;
    try {
      final response = await _dio.get(endpoint);
      final data = response.data;
      final body = data['data'];

      if (body is List) {
        return body.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return null;
    } on DioException catch (e, st) {
      _logger.e('getProducts failed ($endpoint)', error: e, stackTrace: st);
      return null;
    } catch (e, st) {
      _logger.e('getProducts failed ($endpoint)', error: e, stackTrace: st);
      return null;
    }
  }

  /// GET /api/products/:id — returns product map or null on error.
  Future<Map<String, dynamic>?> getProductById(String id) async {
    final endpoint = AppConstants.productDetailsEndpoint(id);
    try {
      final response = await _dio.get(endpoint);
      final data = response.data;
      final body = data['data'];
      if (body is Map) return Map<String, dynamic>.from(body);
      return null;
    } on DioException catch (e, st) {
      _logger.e('getProductById failed ($endpoint)', error: e, stackTrace: st);
      return null;
    } catch (e, st) {
      _logger.e('getProductById failed ($endpoint)', error: e, stackTrace: st);
      return null;
    }
  }

  /// GET /api/plans — returns list of plan maps or null on error.
  Future<List<Map<String, dynamic>>?> getPlans() async {
    const endpoint = AppConstants.plansEndpoint;
    try {
      final response = await _dio.get(endpoint);
      final data = response.data;
      final body = data['data'];

      if (body is List) {
        return body.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return null;
    } on DioException catch (e, st) {
      _logger.e('getPlans failed ($endpoint)', error: e, stackTrace: st);
      return null;
    } catch (e, st) {
      _logger.e('getPlans failed ($endpoint)', error: e, stackTrace: st);
      return null;
    }
  }

  /// GET /health — returns response map or null on error.
  Future<Map<String, dynamic>?> getHealth() async {
    const endpoint = AppConstants.healthEndpoint;
    try {
      final response = await _dio.get(endpoint);
      final data = response.data;
      final body = (data is Map && data.containsKey('data')) ? data['data'] : data;
      if (body is Map) return Map<String, dynamic>.from(body);
      return null;
    } on DioException catch (e, st) {
      _logger.e('getHealth failed ($endpoint)', error: e, stackTrace: st);
      return null;
    } catch (e, st) {
      _logger.e('getHealth failed ($endpoint)', error: e, stackTrace: st);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOrderStatus() async {
    const endpoint = AppConstants.orderStatusEndpoint;
    try {
      final response = await _dio.get(endpoint);
      final data = response.data;
      final body = (data is Map && data.containsKey('data')) ? data['data'] : data;
      if (body is Map) return Map<String, dynamic>.from(body);
      return null;
    } on DioException catch (e, st) {
      _logger.e('getOrderStatus failed ($endpoint)', error: e, stackTrace: st);
      return null;
    } catch (e, st) {
      _logger.e('getOrderStatus failed ($endpoint)', error: e, stackTrace: st);
      return null;
    }
  }
}
