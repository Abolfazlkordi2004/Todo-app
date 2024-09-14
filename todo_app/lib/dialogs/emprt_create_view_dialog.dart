import 'package:flutter/material.dart';
import 'package:todo_app/dialogs/generics-dialog.dart';

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
