import 'package:flutter/material.dart';
import 'package:todo_app/helper/function.dart';
import 'package:todo_app/services/cloud/cloud_task.dart';
import 'package:todo_app/services/cloud/firebase_cloud_storage.dart';
import 'package:todo_app/view/create_task_view.dart';

// ignore: must_be_immutable
class TaskListView extends StatefulWidget {
  List<CloudTask> tasks;

  TaskListView({super.key, required this.tasks});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  late List<bool> checkedvalue;
  late TextEditingController _searchBox;
  late FirebaseCloudStorage taskServices;
  Color cardOfColor = Colors.white;

  @override
  void didUpdateWidget(covariant TaskListView oldWidget) {
    if (oldWidget.tasks.length == widget.tasks.length) {
      checkedvalue = List.filled(widget.tasks.length, false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _searchBox = TextEditingController();
    checkedvalue = List.filled(widget.tasks.length, false);
  }

  @override
  void dispose() {
    _searchBox.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextField(
            controller: _searchBox,
            decoration: InputDecoration(
              hintText: 'Search here...',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 1.5),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.tasks.length,
            itemBuilder: (context, index) {
              var task = widget.tasks[index];
              return GestureDetector(
                onLongPress: () async {
                  var updateTask = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CreateTaskView(
                          title: task.title,
                          taskText: task.text,
                          time: task.time,
                          date: task.date,
                        );
                      },
                    ),
                  );
                  if (updateTask != null) {
                    setState(() {
                      widget.tasks = updateTask;
                    });
                  }
                },
                child: Dismissible(
                  key: UniqueKey(),
                  background: swipeRightBackground(),
                  secondaryBackground: swipeLeftBackground(),
                  onDismissed: (direction) {
                    // Instead of deleting from Firebase, we just show a SnackBar
                    if (direction == DismissDirection.startToEnd) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${task.title} marked as completed")),
                      );
                    } else if (direction == DismissDirection.endToStart) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${task.title} deleted locally")),
                      );
                    }

                    // Optionally, you can also remove the task from the local list
                    setState(() {
                      widget.tasks.removeAt(index);
                    });
                  },
                  child: SizedBox(
                    width: 400,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        color: cardOfColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: checkedvalue[index],
                                    onChanged: (bool? newvalue) {
                                      checkedvalue[index] = newvalue ?? false;
                                      if (checkedvalue[index]) {
                                        cardOfColor = Colors.blue.shade100;
                                      } else {
                                        cardOfColor = Colors.white;
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  Text(
                                    task.title.isNotEmpty
                                        ? '${task.title[0].toUpperCase()}${task.title.substring(1)}'
                                        : 'No Title',
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(task.text),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  task.time,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  task.date,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
