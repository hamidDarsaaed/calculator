import 'package:calculator/logic/cubits/calculation/calculation_cubit.dart';
import 'package:calculator/logic/cubits/history/history_cubit.dart';
import 'package:calculator/logic/cubits/theme/theme_cubit.dart';
import 'package:calculator/presentation/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        child: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              return _handleKeyPress(context, event);
            }
            return KeyEventResult.ignored;
          },
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MainScreen(),
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyPress(BuildContext context, KeyDownEvent event) {
    final calculationCubit = context.read<CalculationCubit>();
    final key = event.logicalKey;

    // Numbers
    if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) {
      calculationCubit.onAdd('0');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit1 ||
        key == LogicalKeyboardKey.numpad1) {
      calculationCubit.onAdd('1');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit2 ||
        key == LogicalKeyboardKey.numpad2) {
      calculationCubit.onAdd('2');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit3 ||
        key == LogicalKeyboardKey.numpad3) {
      calculationCubit.onAdd('3');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit4 ||
        key == LogicalKeyboardKey.numpad4) {
      calculationCubit.onAdd('4');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit5 ||
        key == LogicalKeyboardKey.numpad5) {
      if (!HardwareKeyboard.instance.isShiftPressed) {
        calculationCubit.onAdd('5');
        return KeyEventResult.handled;
      }
    } else if (key == LogicalKeyboardKey.digit6 ||
        key == LogicalKeyboardKey.numpad6) {
      calculationCubit.onAdd('6');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit7 ||
        key == LogicalKeyboardKey.numpad7) {
      calculationCubit.onAdd('7');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit8 ||
        key == LogicalKeyboardKey.numpad8) {
      if (!HardwareKeyboard.instance.isShiftPressed) {
        calculationCubit.onAdd('8');
        return KeyEventResult.handled;
      }
    } else if (key == LogicalKeyboardKey.digit9 ||
        key == LogicalKeyboardKey.numpad9) {
      calculationCubit.onAdd('9');
      return KeyEventResult.handled;
    }

    // Operations
    if (key == LogicalKeyboardKey.add || key == LogicalKeyboardKey.numpadAdd) {
      calculationCubit.onAdd('+');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.minus ||
        key == LogicalKeyboardKey.numpadSubtract) {
      calculationCubit.onAdd('-');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.asterisk ||
        key == LogicalKeyboardKey.numpadMultiply) {
      calculationCubit.onAdd('×');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.slash ||
        key == LogicalKeyboardKey.numpadDivide) {
      calculationCubit.onAdd('÷');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.period ||
        key == LogicalKeyboardKey.numpadDecimal) {
      calculationCubit.onAdd('.');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.equal) {
      calculationCubit.onEqual();
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.backspace) {
      calculationCubit.onDelete();
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.escape) {
      calculationCubit.onClear();
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit5 &&
        HardwareKeyboard.instance.isShiftPressed) {
      // Shift + 5 = %
      calculationCubit.onAdd('%');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit8 &&
        HardwareKeyboard.instance.isShiftPressed) {
      // Shift + 8 = *
      calculationCubit.onAdd('×');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit9 &&
        HardwareKeyboard.instance.isShiftPressed) {
      // Shift + 9 = (
      calculationCubit.onAdd('()');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.digit0 &&
        HardwareKeyboard.instance.isShiftPressed) {
      // Shift + 0 = )
      calculationCubit.onAdd('()');
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.keyC &&
        (HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed)) {
      // Ctrl/Cmd + C = Clear
      calculationCubit.onClear();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
