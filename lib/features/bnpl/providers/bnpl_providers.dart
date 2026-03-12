import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:wseela_assessment/features/bnpl/helpers/payments_sched.dart';

import '../models/installment_plan.dart';
import '../models/installment_schedule_item.dart';
import '../models/product.dart';
import '../repository/bnpl_repository.dart';
import '../usecases/get_plans_use_case.dart';

class BnplState {
  const BnplState({
    this.isLoading = false,
    this.errorMessage,
    this.products,
    this.plans,
    this.selectedProduct,
    this.selectedPlan,
    this.orderStatus,
  });

  final bool isLoading;
  final String? errorMessage;
  final List<Product>? products;
  final List<InstallmentPlan>? plans;
  final Product? selectedProduct;
  final InstallmentPlan? selectedPlan;
  final String? orderStatus;

  List<InstallmentScheduleItem>? get installmentSchedule {
    if (selectedProduct == null || selectedPlan == null) return null;
    return PaymentsHelper.buildInstallmentSchedule(
      product: selectedProduct!,
      plan: selectedPlan!,
    );
  }

  BnplState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Product>? products,
    List<InstallmentPlan>? plans,
    Product? selectedProduct,
    InstallmentPlan? selectedPlan,
    String? orderStatus,
  }) {
    return BnplState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      plans: plans ?? this.plans,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }
}

class BnplNotifier extends Notifier<BnplState> {
  @override
  BnplState build() {
    return const BnplState();
  }

  BnplRepository get _repo => ref.read(bnplRepositoryProvider);
  GetPlansUseCase get _getPlans => GetPlansUseCase(_repo);

  Future<void> fetchPlans(BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      context.loaderOverlay.show();
      final list = await _getPlans();
      state = state.copyWith(
        isLoading: false,
        plans: list,
        errorMessage: list == null ? 'Failed to load plans' : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    } finally {
      if (context.mounted) context.loaderOverlay.hide();
    }
  }

  Future<void> loadPlans(BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _getPlans();
      state = state.copyWith(
        isLoading: false,
        plans: list,
        errorMessage: list == null ? 'Failed to load plans' : null,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load installment plans')),
        );
      }
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchProductById(BuildContext context, String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      context.loaderOverlay.show();
      final data = await _repo.getProductById(id);
      final product = data != null ? Product.fromJson(data) : null;
      state = state.copyWith(
        isLoading: false,
        selectedProduct: product,
        errorMessage: product == null ? 'Failed to load product' : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load product details')),
        );
      }
    } finally {
      if (context.mounted) context.loaderOverlay.hide();
    }
  }

  Future<String?> getOrderStatus(BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      context.loaderOverlay.show();
      final response = await _repo.getOrderStatus();
      final status = response?['status'] as String?;
      state = state.copyWith(
        isLoading: false,
        orderStatus: status,
        errorMessage: status == null ? 'Failed to load order status' : null,
      );
      return status;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get the order status')),
        );
      }
      state = state.copyWith(isLoading: false, errorMessage: e.toString());

      return null;
    } finally {
      if (context.mounted) context.loaderOverlay.hide();
    }
  }

  void setSelectedProduct(Product? product) {
    state = state.copyWith(selectedProduct: product);
  }

  void setSelectedPlan(InstallmentPlan? plan) {
    state = state.copyWith(selectedPlan: plan);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final bnplRepositoryProvider = Provider<BnplRepository>((ref) {
  return BnplRepository();
});

final bnplNotifierProvider = NotifierProvider<BnplNotifier, BnplState>(
  BnplNotifier.new,
);
