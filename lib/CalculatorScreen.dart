import 'package:calculator/config.dart';
import 'package:calculator/logic/cubits/calculation/calculation_cubit.dart';
import 'package:calculator/logic/cubits/history/history_cubit.dart';
import 'package:calculator/logic/cubits/theme/theme_cubit.dart';
import 'package:calculator/presentation/components/custom_scroll_behavior.dart';
import 'package:calculator/presentation/designs/app_theme.dart';
import 'package:calculator/presentation/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorScreen extends StatelessWidget {
  Function(num?)? onClickEqual;
  CalculatorScreen({super.key, this.onClickEqual});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HistoryCubit>(
          create: (context) => HistoryCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocProvider<CalculationCubit>(
        create: (context) => CalculationCubit(
          historyCubit: context.read<HistoryCubit>(),
          onClickEqual: onClickEqual,
        ),
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: MainScreen(),
        ),
      ),
    );
  }
}
