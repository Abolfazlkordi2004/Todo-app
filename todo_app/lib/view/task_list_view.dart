import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/helper/function.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/services/Bloc/task_bloc.dart';
import 'package:todo_app/services/Bloc/task_event_bloc.dart';
import 'package:todo_app/view/create_update_task_view.dart';

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
  late TaskServices _taskServices;

  @override
  void didUpdateWidget(covariant TaskListView oldWidget) {
    if (oldWidget.tasks.length != widget.tasks.length) {
      checkedvalue = List.filled(widget.tasks.length, false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _searchBox = TextEditingController();
    checkedvalue = List.filled(widget.tasks.length, false);
    filteredTask = List.from(widget.tasks);
    _searchBox.addListener(_onSearchChanged);
    _taskServices = TaskServices();
  }

  @override
  void dispose() {
    _searchBox.removeListener(_onSearchChanged);
    _searchBox.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchBox.text.isEmpty) {
        filteredTask = List.from(widget.tasks);
      } else {
        String searchText = _searchBox.text.toLowerCase();
        filteredTask = widget.tasks
            .where((task) => task[0].toLowerCase().contains(searchText))
            .toList();
      }
    });
  }

  void editTask(String title, String text, String time, String date) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateTaskView(
          taskServices: context.read<TaskBloc>().taskServices,
          title: title,
          taskText: text,
          time: time,
          date: date,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive().init(constraints: constraints);
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(3.5 * Responsive().widthConfige),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: _searchBox,
                  decoration: InputDecoration(
                    hintText: 'جستجو کنید ',
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
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTask.length,
                itemBuilder: (context, index) {
                  var task = filteredTask[index];
                  return GestureDetector(
                    onLongPress: () {
                      editTask(task[0], task[1], task[2], task[3]);
                    },
                    child: Dismissible(
                      key: UniqueKey(),
                      background: swipeRightBackground(),
                      secondaryBackground: swipeLeftBackground(),
                      onDismissed: (direction) {
                        final removedTask = widget.tasks[index];
                        setState(() {
                          BlocProvider.of<TaskBloc>(context)
                              .add(RemoveTask(task));
                          widget.tasks.removeAt(index);
                          filteredTask.removeAt(index);
                        });
                        _taskServices.removeTasks(removedTask);
                        if (direction == DismissDirection.startToEnd) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text("انجام شد ${removedTask[0]}"),
                              ),
                            ),
                          );
                        } else if (direction == DismissDirection.endToStart) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text("حذف شد ${removedTask[0]}"),
                              ),
                            ),
                          );
                        }
                      },
                      child: SizedBox(
                        width: 100 * Responsive().widthConfige,
                        height: 25 * Responsive().heightConfige,
                        child: Padding(
                          padding:
                              EdgeInsets.all(1 * Responsive().widthConfige),
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    4 * Responsive().widthConfige,
                                    4 * Responsive().widthConfige,
                                    0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${task[0][0].toUpperCase()}${task[0].substring(1)}',
                                      style: TextStyle(
                                        fontSize: 2 * Responsive().textConfige,
                                      ),
                                    ),
                                  ),
                                ),
                                heightSizedBox(1),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    4 * Responsive().widthConfige,
                                    0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(task[1]),
                                  ),
                                ),
                                heightSizedBox(3.5),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    task[2],
                                    style: TextStyle(
                                      fontSize: 1.7 * Responsive().textConfige,
                                    ),
                                  ),
                                ),
                                heightSizedBox(1),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    task[3],
                                    style: TextStyle(
                                      fontSize: 1.7 * Responsive().textConfige,
                                    ),
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
              ),
            ),
          ],
        );
      },
    );
  }
}
