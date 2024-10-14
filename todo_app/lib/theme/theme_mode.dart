import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  hintColor: Colors.blueAccent,
  textTheme: PersianFonts.vazirTextTheme,
);
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[400],
  hintColor: Colors.blueAccent,
  textTheme: PersianFonts.vazirTextTheme,
);
