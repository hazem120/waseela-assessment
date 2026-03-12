import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:wseela_assessment/core/utils/colors.dart';
import 'package:wseela_assessment/features/bnpl/views/checkout_screen.dart';

void main() => runApp(ProviderScope(child: const App()));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wseela',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppColors.primary,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: LoaderOverlay(child: CheckoutScreen()),
    );
  }
}
