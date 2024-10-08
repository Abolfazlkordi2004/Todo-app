import 'package:flutter/material.dart';
import 'package:todo_app/utilities.dart/dialogs/generics_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showgGenericsDialog<bool>(
    context: context,
    text: 'Are you sure to logout?',
    title: 'Log out',
    optionBuilder: () => {
      'Cancel': false,
      'LogOut': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
