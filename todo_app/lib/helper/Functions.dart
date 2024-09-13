import 'package:flutter/material.dart';

Widget swipeRightBackground() {
  return Container(
    color: Colors.blue.shade100,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: const Icon(Icons.check, color: Colors.black),
  );
}

Widget swipeLeftBackground() {
  return Container(
    color: Colors.blue.shade100,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: const Icon(Icons.delete, color: Colors.black),
  );
}
