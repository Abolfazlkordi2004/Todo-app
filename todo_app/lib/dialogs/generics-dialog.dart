import 'package:flutter/material.dart';

typedef DialogBuilder<T> = Map<String, T?> Function();

Future<T?> showgGenericsDialog<T>({
  required BuildContext context,
  required String? text,
  required String? title,
  required DialogBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title!),
        content: Text(text!),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle));
        }).toList(),
      );
    },
  );
}
