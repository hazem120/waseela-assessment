import 'package:wseela_assessment/features/bnpl/models/installment_plan.dart';
import 'package:wseela_assessment/features/bnpl/models/installment_schedule_item.dart';
import 'package:wseela_assessment/features/bnpl/models/product.dart';

class PaymentsHelper {
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
