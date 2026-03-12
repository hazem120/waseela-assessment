import 'package:dio/dio.dart';
import 'package:wseela_assessment/features/bnpl/models/installment_plan.dart';
import 'package:wseela_assessment/features/bnpl/models/product.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/constants.dart';
import '../models/installment_schedule_item.dart';

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
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      return null;
    } on DioException {
      return null;
    }
  }

  /// GET /api/plans — returns list of plan maps or null on error.
  Future<List<Map<String, dynamic>>?> getPlans() async {
    try {
      final response = await _dio.get(AppConstants.plansEndpoint);
      final data = response.data;
      if (data is List<dynamic>) {
        return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return null;
    } on DioException {
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
    }
  }

  static List<InstallmentScheduleItem> buildInstallmentSchedule({
    required Product product,
    required InstallmentPlan plan,
    DateTime? startDate,
  }) {
    final price = product.price;
    final months = plan.months;
    final interestRate = plan.interestRate;
    final adminFee = plan.adminFee;

    final interest = price * interestRate;
    final totalPayable = price + interest + adminFee;
    final monthlyAmount = totalPayable / months;
    final now = startDate ?? DateTime.now();
    final List<InstallmentScheduleItem> items = [];

    for (var i = 0; i < months; i++) {
      final dueDate = DateTime(now.year, now.month + i + 1, now.day);
      items.add(
        InstallmentScheduleItem(
          installmentNumber: i + 1,
          dueDate: dueDate,
          amount: double.parse((monthlyAmount).toStringAsFixed(2)),
        ),
      );
    }
    return items;
  }
}
