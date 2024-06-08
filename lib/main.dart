import 'dart:developer';

import 'package:calculator/CalculatorScreen.dart';
import 'package:calculator/initialize.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitializeService.init();

  runApp(MaterialApp(
    locale: Locale("ar"),
    home: CalculatorScreen(
      onClickEqual: (val) {
      },
    ),
  ));
}
