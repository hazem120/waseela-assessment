class InstallmentScheduleItem {
  const InstallmentScheduleItem({
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
  });

  final int installmentNumber;
  final DateTime dueDate;
  final double amount;

  factory InstallmentScheduleItem.fromJson(Map<String, dynamic> json) {
    return InstallmentScheduleItem(
      installmentNumber: (json['installmentNumber'] as num).toInt(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

