import 'package:flutter/material.dart';

class Responsive {
  double widthConfige;
  double heightConfige;
  double textConfige;
  double imageConfige;

  Responsive._sharedConstructor({
    required this.heightConfige,
    required this.widthConfige,
    required this.textConfige,
    required this.imageConfige,
  });

  static final Responsive _shared = Responsive._sharedConstructor(
    heightConfige: 0,
    widthConfige: 0,
    textConfige: 0,
    imageConfige: 0,
  );

  factory Responsive() => _shared;

  void init({required BoxConstraints constraints}) {
    heightConfige = constraints.maxHeight / 100;
    widthConfige = constraints.maxWidth / 100;
    textConfige = constraints.maxHeight / 100;
    imageConfige = constraints.maxWidth / 100;
  }
}
