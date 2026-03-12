import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:wseela_assessment/core/utils/colors.dart';
import 'package:wseela_assessment/features/bnpl/models/installment_plan.dart';
import 'package:wseela_assessment/features/bnpl/models/product.dart';
import 'package:wseela_assessment/features/bnpl/providers/bnpl_providers.dart';
import 'package:wseela_assessment/features/bnpl/views/select_plan_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bnplNotifierProvider.notifier).fetchPlans(context);
      ref
          .read(bnplNotifierProvider.notifier)
          .fetchProductById(context, 'prod_001');
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bnplNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.selectedProduct != null)
              _ProductCard(product: state.selectedProduct!),
            const SizedBox(height: 24),
            const Text(
              'BNPL Installment Plans',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            if (state.plans != null && state.plans!.isNotEmpty)
              _PlanSelector(
                selectedPlan: state.selectedPlan,
                plans: state.plans!,
                onSelect: (plan) {
                  ref.read(bnplNotifierProvider.notifier).setSelectedPlan(plan);
                },
              ),
            const SizedBox(height: 16),
            if (state.selectedPlan != null && state.selectedProduct != null)
              _PlanDetails(
                plan: state.selectedPlan!,
                product: state.selectedProduct!,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SelectPlanScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Buy Now, Pay Later',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: AppColors.primary,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanSelector extends StatelessWidget {
  final InstallmentPlan? selectedPlan;
  final List<InstallmentPlan> plans;
  final ValueChanged<InstallmentPlan> onSelect;

  const _PlanSelector({
    required this.selectedPlan,
    required this.plans,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: plans
          .map(
            (plan) => Expanded(
              child: GestureDetector(
                onTap: () => onSelect(plan),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedPlan?.id == plan.id
                        ? AppColors.selectedPlan
                        : AppColors.unselectedPlan,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${plan.months}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: selectedPlan?.id == plan.id
                              ? AppColors.textOnPrimary
                              : AppColors.primary,
                        ),
                      ),
                      Text(
                        'months',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: selectedPlan?.id == plan.id
                              ? AppColors.textOnPrimary
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PlanDetails extends StatelessWidget {
  final InstallmentPlan plan;
  final Product product;

  const _PlanDetails({required this.plan, required this.product});

  @override
  Widget build(BuildContext context) {
    final totalAmount =
        product.price * (1 + (plan.interestRate / 100)) + plan.adminFee;
    final monthlyPayment = totalAmount / plan.months;
    final fee = (plan.interestRate / 100 * product.price) + plan.adminFee;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _DetailRow(
            label: 'Monthly:',
            value: '\$${monthlyPayment.toStringAsFixed(2)}',
          ),
          _DetailRow(
            label: 'Total:',
            value: '\$${totalAmount.toStringAsFixed(2)}',
            bold: true,
          ),
          _DetailRow(
            label: 'Fees/Interest:',
            value: '\$${fee.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
