import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wseela_assessment/core/utils/colors.dart';
import 'package:wseela_assessment/features/bnpl/helpers/payments_sched.dart';
import 'package:wseela_assessment/features/bnpl/models/installment_plan.dart';
import 'package:wseela_assessment/features/bnpl/models/installment_schedule_item.dart';
import 'package:wseela_assessment/features/bnpl/models/product.dart';
import 'package:wseela_assessment/features/bnpl/providers/bnpl_providers.dart';
import 'package:wseela_assessment/features/bnpl/views/order_confirmation.dart';

class SelectPlanScreen extends ConsumerWidget {
  const SelectPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bnplNotifierProvider);

    if (state.plans == null || state.selectedProduct == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final plans = state.plans!;
    final product = state.selectedProduct!;
    final selectedPlan = state.selectedPlan;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text(
          'Select Plan',
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
            if (selectedPlan != null)
              _SelectedPlanBanner(plan: selectedPlan, product: product),
            const SizedBox(height: 12),
            ...plans.map(
              (plan) => _PlanOption(
                plan: plan,
                product: product,
                isSelected: selectedPlan?.id == plan.id,
                onTap: () => ref
                    .read(bnplNotifierProvider.notifier)
                    .setSelectedPlan(plan),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedPlan != null)
              _RepaymentSchedule(plan: selectedPlan, product: product),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: ElevatedButton(
          onPressed: () {
            if (state.selectedPlan == null) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderConfirmationScreen()),
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
            'Continue to Confirmation',
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

class _SelectedPlanBanner extends StatelessWidget {
  final InstallmentPlan plan;
  final Product product;

  const _SelectedPlanBanner({required this.plan, required this.product});

  @override
  Widget build(BuildContext context) {
    final items = PaymentsHelper.buildInstallmentSchedule(
      product: product,
      plan: plan,
    );
    final monthly = items.first.amount;
    final total = monthly * plan.months;
    final fee = (plan.interestRate * product.price) + plan.adminFee;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${plan.months} Months Plan Selected:',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\$${monthly.toStringAsFixed(2)}/mo  |  Total \$${total.toStringAsFixed(2)}  |  \$${fee.toStringAsFixed(0)} Fee',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  final InstallmentPlan plan;
  final Product product;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanOption({
    required this.plan,
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = PaymentsHelper.buildInstallmentSchedule(
      product: product,
      plan: plan,
    );
    final monthly = items.first.amount;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedPlan : AppColors.unselectedPlan,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${plan.months} Months (${plan.label})',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.textOnPrimary : AppColors.primary,
              ),
            ),
            Text(
              '\$${monthly.toStringAsFixed(2)}/mo',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.textOnPrimary : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RepaymentSchedule extends StatelessWidget {
  final InstallmentPlan plan;
  final Product product;

  const _RepaymentSchedule({required this.plan, required this.product});

  @override
  Widget build(BuildContext context) {
    final items = PaymentsHelper.buildInstallmentSchedule(
      product: product,
      plan: plan,
    );

    final half = (items.length / 2).ceil();
    final left = items.sublist(0, half);
    final right = items.sublist(half);

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
            'Repayment Schedule',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _ScheduleColumn(entries: left)),
              const SizedBox(width: 16),
              Expanded(child: _ScheduleColumn(entries: right)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScheduleColumn extends StatelessWidget {
  final List<InstallmentScheduleItem> entries;

  const _ScheduleColumn({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${e.installmentNumber}. ${PaymentsHelper.formatDate(e.dueDate)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${e.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
