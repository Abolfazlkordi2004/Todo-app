import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  // primaryColor: const Color.fromARGB(255, 32, 155, 40),
  // hintColor: Colors.blueAccent,
  textTheme: PersianFonts.vazirTextTheme,
);
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  // primaryColor: Colors.grey[100],
  // hintColor: Colors.blueAccent,
  textTheme: PersianFonts.vazirTextTheme,
);
