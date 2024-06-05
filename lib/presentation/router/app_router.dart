import 'package:calculator/logic/cubits/calculation/calculation_cubit.dart';
import 'package:calculator/logic/cubits/history/history_cubit.dart';
import 'package:calculator/presentation/screens/main/main_screen.dart';
import 'package:calculator/presentation/screens/not_found/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    try {
      switch (routeSettings.name) {
        case MainScreen.routeName:
          return MaterialPageRoute(
            builder: (context) => BlocProvider<CalculationCubit>(
              create: (context) => CalculationCubit(
                historyCubit: context.read<HistoryCubit>(),
              ),
              child: const MainScreen(),
            ),
          );

        default:
          return MaterialPageRoute(
            builder: (context) => const NotFoundScreen(),
          );
      }
    } catch (e) {
      return MaterialPageRoute(
        builder: (context) => const NotFoundScreen(),
      );
    }
  }
}
