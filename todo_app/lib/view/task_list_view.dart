import 'package:flutter/material.dart';
import 'package:todo_app/constant/username.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final task = taskList?.elementAt(index);
        return ListTile(
          leading: Text(task!),
        );
      },
    );
  }
}
