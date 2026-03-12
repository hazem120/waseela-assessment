import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wseela_assessment/features/bnpl/providers/bnpl_providers.dart';
import 'package:wseela_assessment/features/bnpl/repository/bnpl_repository.dart';
import 'package:wseela_assessment/features/bnpl/views/checkout_screen.dart';

class _MockBnplRepository extends Mock implements BnplRepository {}

void main() {
  testWidgets('CheckoutScreen renders product and plans, selecting a plan shows details',
      (WidgetTester tester) async {
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
        {
          'id': 'plan_6m',
          'months': 6,
          'label': '6 Months',
          'interestRate': 0.0,
          'adminFee': 0.0,
          'description': 'Pay in 6 equal installments – 0% interest',
        },
      ],
    );

    when(() => repo.getProductById('prod_001')).thenAnswer(
      (_) async => {
        'id': 'prod_001',
        'name': 'iPhone 15 Pro',
        'description': 'Test description',
        'price': 4999.0,
        // Keep image empty so Image.network is not used in tests.
        'imageUrl': '',
      },
    );

    final container = ProviderContainer(
      overrides: [
        bnplRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: LoaderOverlay(
            child: CheckoutScreen(),
          ),
        ),
      ),
    );

    // First frame.
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('BNPL Installment Plans'), findsOneWidget);

    // Let postFrameCallback run and async calls complete.
    await tester.pump(); // schedule callback
    await tester.pumpAndSettle();

    // Product card should render.
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('\$4999.00'), findsOneWidget);

    // Plans should render (months labels).
    expect(find.text('3'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);

    // Selecting a plan shows plan details.
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    expect(find.text('Plan Details'), findsOneWidget);
    expect(find.text('Monthly:'), findsOneWidget);
    expect(find.text('Total:'), findsOneWidget);
    expect(find.text('Fees/Interest:'), findsOneWidget);
  });
}

