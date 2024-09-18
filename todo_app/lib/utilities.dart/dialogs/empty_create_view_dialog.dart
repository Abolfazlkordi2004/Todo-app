import 'package:flutter/material.dart';
import 'package:todo_app/utilities.dart/dialogs/generics_dialog.dart';

Future<void> showEmptyTextDialog(BuildContext context, String text) {
  return showgGenericsDialog(
    context: context,
    text: text,
    title: 'Error',
    optionBuilder: () => {
      'Ok': Null,
    },
  );
}
