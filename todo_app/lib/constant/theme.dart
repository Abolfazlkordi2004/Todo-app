import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
 
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey.shade900,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
 
);
