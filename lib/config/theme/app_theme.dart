// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppTheme{
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Color.fromARGB(255, 245, 28, 147),
  );
}