import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wseela_assessment/features/bnpl/providers/bnpl_providers.dart';
import 'package:wseela_assessment/features/bnpl/repository/bnpl_repository.dart';

class _MockBnplRepository extends Mock implements BnplRepository {}

void main() {
  test('BnplNotifier.loadPlans sets plans on success', () async {
    final repo = _MockBnplRepository();

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

    final container = ProviderContainer(
      overrides: [
        bnplRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(bnplNotifierProvider.notifier);

    await notifier.loadPlans();

    final state = container.read(bnplNotifierProvider);
    expect(state.isLoading, isFalse);
    expect(state.errorMessage, isNull);
    expect(state.plans, isNotNull);
    expect(state.plans, hasLength(1));
    expect(state.plans!.first.id, 'plan_3m');
  });

  test('BnplNotifier.loadPlans sets errorMessage when repo returns null', () async {
    final repo = _MockBnplRepository();

    when(() => repo.getPlans()).thenAnswer((_) async => null);

    final container = ProviderContainer(
      overrides: [
        bnplRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(bnplNotifierProvider.notifier);

    await notifier.loadPlans();

    final state = container.read(bnplNotifierProvider);
    expect(state.isLoading, isFalse);
    expect(state.plans, isNull);
    expect(state.errorMessage, isNotNull);
  });
}

