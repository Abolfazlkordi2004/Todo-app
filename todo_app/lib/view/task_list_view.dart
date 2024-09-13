import 'package:flutter/material.dart';

class TaskListView extends StatefulWidget {
  final List<List<String>> tasks;

  const TaskListView({super.key, required this.tasks});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  late List<bool> checkedvalue;

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
    checkedvalue = List.filled(widget.tasks.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final task = widget.tasks[index];

        return Dismissible(
          key: Key(task[0]),
          background: swipeRightBackground(),
          secondaryBackground: swipeLeftBackground(),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${task[0]} task completed")),
              );
            } else if (direction == DismissDirection.endToStart) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${task[0]} task deleted")),
              );
            }
          },
          child: SizedBox(
            width: 400,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
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
                              setState(() {});
                            },
                          ),
                          Text(
                            '${task[0][0].toUpperCase()}${task[0].substring(1)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(task[1]),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          task[2],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          task[3],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Background when swiping right
  Widget swipeRightBackground() {
    return Container(
      color: Colors.blue.shade100,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: const Icon(Icons.check, color: Colors.black),
    );
  }

  // Background when swiping left
  Widget swipeLeftBackground() {
    return Container(
      color: Colors.blue.shade100,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: const Icon(Icons.delete, color: Colors.black),
    );
  }
}
