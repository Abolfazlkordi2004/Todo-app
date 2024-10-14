import 'package:flutter/material.dart';

Future<void> showErrordialog(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('خطا'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'تایید',
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
    },
  );
}
