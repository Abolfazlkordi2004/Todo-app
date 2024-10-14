import 'package:flutter/material.dart';
import 'package:todo_app/utilities.dart/dialogs/generics_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showgGenericsDialog<bool>(
    context: context,
    text: 'ایا میخواهید خارج شوید?',
    title: 'خروج',
    optionBuilder: () => {
      'لغو': false,
      'تایید': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
