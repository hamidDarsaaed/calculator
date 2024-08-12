import 'package:calculator/logic/cubits/calculation/calculation_cubit.dart';
import 'package:calculator/logic/cubits/history/history_cubit.dart';
import 'package:calculator/logic/cubits/theme/theme_cubit.dart';
import 'package:calculator/presentation/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CalculatorScreen extends StatelessWidget {
  Function(num?)? onClickEqual;
  Locale? locale;
  String? titleBtnClick;
  Color? colorBtn;
  CalculatorScreen({
    super.key,
    this.onClickEqual,
    this.locale,
    this.titleBtnClick,
    this.colorBtn,
  });

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
            titleBtnClick: titleBtnClick,
            colorBtn: colorBtn,
            locale: locale),
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: MainScreen(),
        ),
      ),
    );
  }
}
