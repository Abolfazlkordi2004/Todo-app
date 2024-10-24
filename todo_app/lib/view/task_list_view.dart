import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/helper/Function/function.dart';
import 'package:todo_app/helper/loading/loading_screen.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_bloc.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_event.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_state.dart';
import 'package:todo_app/view/update_task_view.dart';

class TaskListView extends StatefulWidget {
  final List<List<String>> tasks;

  const TaskListView({super.key, required this.tasks});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  late TextEditingController _searchBox;
  late List<List<String>> filteredTask;
  late TaskServices _taskServices;

  @override
  void initState() {
    super.initState();
    _searchBox = TextEditingController();
    filteredTask = widget.tasks;
    _taskServices = TaskServices();
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
        filteredTask = _searchBox.text.isEmpty
            ? widget.tasks
            : widget.tasks
                .where((task) => task[0]
                    .toLowerCase()
                    .contains(_searchBox.text.toLowerCase()))
                .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: 'لطفا صبر کنید');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        return GestureDetector(
          // onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Column(
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
                          onPressed: () {
                            context
                                .read()
                                .add(SearchTaskEvent(_searchBox.text));
                            _onSearchChanged();
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredTask.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/iconTask.png'),
                              heightSizedBox(1),
                              Text(
                                'هدف جدیدی ایجاد کنید',
                                style: TextStyle(
                                  fontSize: 1.7 * Responsive().textConfige,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredTask.length,
                          itemBuilder: (context, index) {
                            var task = filteredTask[index];
                            return buildTaskCard(context, task, index);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTaskCard(BuildContext context, List<String> task, int index) {
    return Dismissible(
      key: Key(task[0]),
      background: swipeRightBackground(),
      secondaryBackground: swipeLeftBackground(),
      onDismissed: (direction) {
        final removedTask = widget.tasks[index];
        setState(() {
          // widget.tasks.removeAt(index);
          // _taskServices.removeTasks(removedTask);
          context.read<TaskBloc>().add(DeleteTaskEvent(removedTask));
        });

        final message = direction == DismissDirection.startToEnd
            ? "${removedTask[0]} انجام شد"
            : "${removedTask[0]} حذف شد";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(message),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.lightBlue.shade100,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    4 * Responsive().widthConfige,
                    4 * Responsive().widthConfige,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          color: Colors.black,
                          onPressed: () async {
                            var updateTask = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return UpdateTaskView(
                                    taskServices: _taskServices,
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
                          icon: const Icon(Icons.edit)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${task[0][0].toUpperCase()}${task[0].substring(1)}',
                          style: TextStyle(
                            fontSize: 2 * Responsive().textConfige,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )),
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
                  child: Text(
                    task[1],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              heightSizedBox(3.5),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  task[2],
                  style: TextStyle(
                    fontSize: 1.7 * Responsive().textConfige,
                    color: Colors.black,
                  ),
                ),
              ),
              heightSizedBox(0.5),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  task[3],
                  style: TextStyle(
                    fontSize: 1.7 * Responsive().textConfige,
                    color: Colors.black,
                  ),
                ),
              ),
              heightSizedBox(1),
            ],
          ),
        ),
      ),
    );
  }
}
