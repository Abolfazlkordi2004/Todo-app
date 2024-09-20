import 'package:flutter/material.dart';
import 'package:todo_app/Responsive/responsive.dart';

Widget widthSizedBox(double size) {
  return SizedBox(
    width: size * Responsive().widthConfige,
  );
}

Widget heightSizedBox(double size) {
  return SizedBox(
    height: size * Responsive().heightConfige,
  );
}
