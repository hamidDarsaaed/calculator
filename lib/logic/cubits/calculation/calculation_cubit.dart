import 'dart:developer';

import 'package:calculator/data/models/calculation.dart';
import 'package:calculator/helpers/utils.dart';
import 'package:calculator/logic/cubits/history/history_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';

part 'calculation_state.dart';

class CalculationCubit extends Cubit<CalculationState> {
  final HistoryCubit _historyCubit;
  Function(num?)? onClickEqual;

  CalculationCubit({
    required HistoryCubit historyCubit,
    this.onClickEqual,
  })  : _historyCubit = historyCubit,
        super(const CalculationState());

  void clickBtnToPaymentPage(BuildContext cxt) {
    bool isRtl = Localizations.localeOf(cxt).languageCode == "ar";
    // log("isRtl ::: ${Localizations.localeOf(cxt).languageCode}");
    if (state.answer! <= 0) {
      ScaffoldMessenger.of(cxt).showSnackBar(
        SnackBar(
            content: Text(isRtl
                ? "يجب أن يكون المبلغ أكبر من الصفر."
                : 'The amount must be higher than zero.')),
      );
      return;
    }

    if (onClickEqual != null) {
      onClickEqual!(state.answer);
      Navigator.pop(cxt);
    }
  }

  void onAdd(String value) {
    try {
      emit(state.copyWith(isError: false, error: null));
      String question = state.question;
      String input = value;
      bool isInitial = state.isInitial;
      List<String> questionSplit = state.questionSplit;
      String last = question[question.length - 1];
      int lastOperatorIndex = question.split('').lastIndexWhere((element) =>
          Utils.isParentheses(element) ||
          element == '%' ||
          element == '÷' ||
          element == '×' ||
          element == '-' ||
          element == '+');

      /// Check if input value is number
      if (Utils.isNumber(input)) {
        /// Check if input digits too long
        bool isTooLong = (question.length - lastOperatorIndex) > 15;
        if (isTooLong) {
          throw 'Can\'t enter more than 15 digits';
        }
        if (last == ')' || last == '%') {
          input = '×$input';
        }
      }

      /// Check if input value is parentheses
      bool isParentheses = Utils.isParentheses(input);
      if (isParentheses) {
        input = '';
        if (isInitial) {
          input = '(';
        } else {
          if (last == '(' ||
              last == '÷' ||
              last == '×' ||
              last == '-' ||
              last == '+') {
            input = '(';
          } else if (last == ')') {
            input = ')';
          } else if (Utils.isNumber(last) || last == '%') {
            if (question.contains('(')) {
              input = ')';
            } else {
              input = '×(';
            }
          } else {
            throw 'Invalid format used.';
          }
        }
      }

      /// Check if input value is percentage
      bool isPercentage = input == '%';
      if (isPercentage) {
        if (isInitial) {
          input = '0%';
        } else {
          final beforeLast =
              question.length > 3 ? question[question.length - 2] : null;
          if (!Utils.isNumber(last) || (beforeLast == '%' && last == ')')) {
            throw 'Invalid format used.';
          }
        }
      }

      /// Check if input value is division
      bool isDivision = input == '÷';
      if (isDivision) {
        if (isInitial) {
          input = '0÷';
        } else {
          if (last == '.') {
            throw 'Invalid format used.';
          }
          final end = Utils.isNumber(last) || last == ')' || last == '%'
              ? question.length
              : question.length - 1;
          question = question.substring(0, end);
        }
      }

      /// Check if input value is multiplication
      bool isMultiplication = input == '×';
      if (isMultiplication) {
        if (isInitial) {
          input = '0×';
        } else {
          if (last == '.') {
            throw 'Invalid format used.';
          }
          final end = Utils.isNumber(last) || last == ')' || last == '%'
              ? question.length
              : question.length - 1;
          question = question.substring(0, end);
        }
      }

      /// Check if input value is plus
      bool isPlus = input == '+';
      if (isPlus) {
        if (isInitial) {
          input = '0+';
        } else {
          if (last == '.') {
            throw 'Invalid format used.';
          }
          final end = Utils.isNumber(last) || last == ')' || last == '%'
              ? question.length
              : question.length - 1;
          question = question.substring(0, end);
        }
      }

      /// Check if input value is minus
      bool isMinus = input == '-';
      if (isMinus) {
        if (isInitial) {
          input = '0-';
        } else {
          if (last == '.') {
            throw 'Invalid format used.';
          }
          final end =
              Utils.isNumber(last) || Utils.isParentheses(last) || last == '%'
                  ? question.length
                  : question.length - 1;
          question = question.substring(0, end);
        }
      }

      /// Check if input value is negative
      bool isNegative = input == '+/-';
      if (isNegative) {
        if (isInitial) {
          input = '(-';
        } else {
          final isNegativeUsed = questionSplit
                  .getRange(questionSplit.length - 2, questionSplit.length)
                  .join() ==
              '(-';
          if (isNegativeUsed) {
            question = question.substring(0, question.length - 2);
            input = questionSplit.length == 2 ? '0' : '';
          } else {
            if (last == ')' || last == '%') {
              input = '×(-';
            } else if (Utils.isNumber(last) || last == '.') {
              final start = questionSplit.lastIndexWhere(
                  (element) => !Utils.isNumber(element) && element != '.');
              final end = questionSplit.lastIndexWhere(
                  (element) => Utils.isNumber(element) || element == '.');
              bool isNegativeUsed = false;
              if (start > 0) {
                isNegativeUsed =
                    questionSplit.getRange(start - 1, start + 1).join() == '(-';
              }
              final numbers = questionSplit.getRange(start + 1, end + 1).join();
              question =
                  question.substring(0, isNegativeUsed ? start - 1 : start + 1);
              input = isNegativeUsed ? numbers : '(-$numbers';
            } else {
              input = '(-';
            }
          }
        }
      }

      /// Check if input value is decimal
      bool isDecimal = input == '.';
      if (isDecimal) {
        if (isInitial) {
          input = '0.';
        } else {
          if (Utils.isNumber(last) || last == '.') {
            final start = questionSplit.lastIndexWhere(
                (element) => !Utils.isNumber(element) || element == '.');
            bool isDecimalUsed = start >= 0
                ? questionSplit
                    .getRange(start, question.length)
                    .join()
                    .contains('.')
                : false;
            if (isDecimalUsed) {
              input = '';
            }
          } else {
            throw 'Invalid format used.';
          }
        }
      }

      final questionFinal = isInitial ? input : question += input;
      emit(state.copyWith(question: questionFinal));
    } catch (e) {
      emit(state.copyWith(isError: true, error: e.toString()));
    }
  }

  void onDelete() {
    emit(state.copyWith(isError: false, error: null));
    String question = state.question;
    bool isLast = question.length == 1;
    emit(state.copyWith(
      question: isLast ? '0' : question.substring(0, question.length - 1),
    ));
    if (isLast) {
      onClear();
    }
  }

  void onEqual() {
    try {
      emit(state.copyWith(isError: false, error: null));
      String question = state.question;
      if (state.isInitial) return;
      question = question.replaceAll('×', '*');
      question = question.replaceAll('%', '*0.01');
      question = question.replaceAll('÷', '/');
      num? result = Parser()
          .parse(question)
          .evaluate(EvaluationType.REAL, ContextModel());
      // log("####### $result");
      final bool isDouble = result != result?.toInt();
      if (!isDouble) {
        result = result?.toInt();
      }
      _historyCubit.onAdd(Calculation(
        question: state.question,
        answer: result,
      ));
      emit(state.copyWith(answer: result));
      // if (onClickEqual != null) {
      //   onClickEqual!(result);
      // }
    } catch (e) {
      emit(state.copyWith(isError: true, error: 'Invalid format used.'));
    }
  }

  void onClear() {
    emit(const CalculationState());
  }
}
