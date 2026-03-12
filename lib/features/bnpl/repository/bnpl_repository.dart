import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/constants.dart';

class BnplRepository {
  BnplRepository({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  /// GET /api/products — returns list of product maps or null on error.
  Future<List<Map<String, dynamic>>?> getProducts() async {
    try {
      final response = await _dio.get(AppConstants.productsEndpoint);
      final data = response.data;
      if (data is List<dynamic>) {
        return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return null;
    } on DioException {
      return null;
    }
  }

  /// GET /api/products/:id — returns product map or null on error.
  Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      final response = await _dio.get(AppConstants.productDetailsEndpoint(id));
      final data = response.data;
      return Map<String, dynamic>.from(data['data'] as Map);
    } on DioException {
      return null;
    } catch (e) {
      return null;
    }
  }

  /// GET /api/plans — returns list of plan maps or null on error.
  Future<List<Map<String, dynamic>>?> getPlans() async {
    try {
      final response = await _dio.get(AppConstants.plansEndpoint);
      final data = response.data;
      return (data['data'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } on DioException {
      return null;
    } catch (e) {
      return null;
    }
  }

  /// GET /health — returns response map or null on error.
  Future<Map<String, dynamic>?> getHealth() async {
    try {
      final response = await _dio.get(AppConstants.healthEndpoint);
      final data = response.data;
      return Map<String, dynamic>.from(data);
    } on DioException {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOrderStatus() async {
    try {
      final response = await _dio.get(AppConstants.orderStatusEndpoint);
      final data = response.data;
      return Map<String, dynamic>.from(data);
    } on DioException {
      return null;
    } catch (e) {
      return null;
    }
  }
}
