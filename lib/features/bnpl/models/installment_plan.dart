class InstallmentPlan {
  const InstallmentPlan({
    required this.id,
    required this.months,
    required this.label,
    required this.interestRate,
    required this.adminFee,
    required this.description,
  });

  final String id;
  final int months;
  final String label;
  final double interestRate;
  final double adminFee;
  final String description;

  factory InstallmentPlan.fromJson(Map<String, dynamic> json) {
    return InstallmentPlan(
      id: json['id'] as String,
      months: (json['months'] as num).toInt(),
      label: json['label'] as String? ?? '',
      interestRate: (json['interestRate'] as num).toDouble(),
      adminFee: (json['adminFee'] as num).toDouble(),
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'months': months,
      'label': label,
      'interestRate': interestRate,
      'adminFee': adminFee,
      'description': description,
    };
  }
}

