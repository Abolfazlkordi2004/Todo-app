import 'package:flutter/material.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/helper/function.dart';
import 'package:todo_app/view/create_task_view.dart';

class TaskListView extends StatefulWidget {
  final List<List<String>> tasks;

  const TaskListView({super.key, required this.tasks});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  late List<bool> checkedvalue;
  late TextEditingController _searchBox;
  late List<List<String>> filteredTask;
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
    filteredTask = widget.tasks;
    _searchBox.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchBox.removeListener(_onSearchChanged);
    _searchBox.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(
      () {
        if (_searchBox.text.isEmpty) {
          filteredTask = widget.tasks;
        } else {
          String searchText = _searchBox.text.toLowerCase();
          filteredTask = widget.tasks
              .where(
                (task) => task[0].toLowerCase().contains(searchText),
              )
              .toList();
        }
      },
    );
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
              suffixIcon: IconButton(
                onPressed: _onSearchChanged,
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredTask.length,
            itemBuilder: (context, index) {
              var task = filteredTask[index];
              return GestureDetector(
                onLongPress: () async {
                  var updateTask = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CreateTaskView(
                          taskServices: TaskServices(),
                          title: task[0],
                          taskText: task[1],
                          time: task[2],
                          date: task[3],
                        );
                      },
                    ),
                  );
                  if (updateTask != null) {
                    setState(() {
                      widget.tasks[index] = updateTask;
                    });
                  }
                },
                child: Dismissible(
                  key: Key(task[0]),
                  background: swipeRightBackground(),
                  secondaryBackground: swipeLeftBackground(),
                  onDismissed: (direction) {
                    widget.tasks.remove(task);
                    if (direction == DismissDirection.startToEnd) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${task[0]} completed")),
                      );
                    } else if (direction == DismissDirection.endToStart) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${task[0]} deleted")),
                      );
                    }
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
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                      '${task[0][0].toUpperCase()}${task[0].substring(1)}',
                                      style: const TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
