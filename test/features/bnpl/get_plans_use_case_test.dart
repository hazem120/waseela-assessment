import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wseela_assessment/features/bnpl/models/installment_plan.dart';
import 'package:wseela_assessment/features/bnpl/repository/bnpl_repository.dart';
import 'package:wseela_assessment/features/bnpl/usecases/get_plans_use_case.dart';

class _MockBnplRepository extends Mock implements BnplRepository {}

void main() {
  test('GetPlansUseCase returns parsed plans when repo returns json', () async {
    final repo = _MockBnplRepository();
    final useCase = GetPlansUseCase(repo);

    when(() => repo.getPlans()).thenAnswer(
      (_) async => [
        {
          'id': 'plan_3m',
          'months': 3,
          'label': '3 Months',
          'interestRate': 0.0,
          'adminFee': 50.0,
          'description': 'Pay in 3 equal installments – 0% interest',
        },
      ],
    );

    final result = await useCase();

    expect(result, isNotNull);
    expect(result, hasLength(1));
    expect(result!.first, isA<InstallmentPlan>());
    expect(result.first.id, 'plan_3m');
    expect(result.first.months, 3);
  });

  test('GetPlansUseCase returns null when repo returns null', () async {
    final repo = _MockBnplRepository();
    final useCase = GetPlansUseCase(repo);

    when(() => repo.getPlans()).thenAnswer((_) async => null);

    final result = await useCase();

    expect(result, isNull);
  });
}

