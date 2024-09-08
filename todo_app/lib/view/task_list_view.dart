import 'package:flutter/material.dart';

class TaskListView extends StatefulWidget {
  final List<String> tasks;
  const TaskListView({super.key, required this.tasks});

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  String? _selectedTask;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final task = widget.tasks.elementAt(index);
        return SizedBox(
          width: 300,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Radio button on the left
                        Radio<String>(
                          value: task,
                          groupValue: _selectedTask,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedTask = value;
                            });
                          },
                        ),
                        // Task text on the right

                        Text(
                          task,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
