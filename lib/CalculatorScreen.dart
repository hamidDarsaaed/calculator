import 'package:calculator/config.dart';
import 'package:calculator/logic/cubits/history/history_cubit.dart';
import 'package:calculator/logic/cubits/theme/theme_cubit.dart';
import 'package:calculator/presentation/components/custom_scroll_behavior.dart';
import 'package:calculator/presentation/designs/app_theme.dart';
import 'package:calculator/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

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
      child: Builder(
        builder: (context) {

          return MaterialApp(
            theme: AppTheme.light,
            // darkTheme: AppTheme.dark,
            // themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            title: Config.appName,
            onGenerateRoute: AppRouter().onGenerateRoute,
            builder: (context, child) => ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: child ?? Container(),
            ),
          );
        },
      ),
    );
  }
}
