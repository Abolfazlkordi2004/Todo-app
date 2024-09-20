import 'package:flutter/material.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/utilities.dart/dialogs/empty_create_view_dialog.dart';

// ignore: must_be_immutable
class CreateTaskView extends StatefulWidget {
  final TaskServices taskServices;
  String? title;
  String? taskText;
  String? time;
  String? date;

  CreateTaskView({
    super.key,
    required this.taskServices,
    this.title,
    this.taskText,
    this.time,
    this.date,
  });

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  late TextEditingController _titleController;
  late TextEditingController _taskController;
  late TextEditingController _timeController;
  late TextEditingController _dateController;

  TimeOfDay nowTime = TimeOfDay.now();
  DateTime nowDate = DateTime.now();

  Future<void> _showTime(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: nowTime,
    );

    if (time != null) {
      _timeController.text = '${time.hour}:${time.minute}';
    }
  }

  Future<void> _showDate(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: nowDate,
      lastDate: DateTime(
        2040,
      ),
    );

    if (date != null) {
      _dateController.text = date.toLocal().toString().split(' ')[0];
    }
  }

  void _addNewTask() async {
    String task = _taskController.text;
    String title = _titleController.text;
    String time = _timeController.text;
    String date = _dateController.text;

    if (task.isNotEmpty &&
        title.isNotEmpty &&
        time.isNotEmpty &&
        date.isNotEmpty) {
      final taskText = [title, task, time, date];
      widget.taskServices.addTask([title, task, time, date]);
      Navigator.of(context).pop(taskText);
    } else if (task.isEmpty || title.isEmpty || time.isEmpty || date.isEmpty) {
      await showEmptyTextDialog(context, 'Please fill all fields');
    }
  }

  @override
  void initState() {
    _taskController = TextEditingController(text: widget.taskText);
    _titleController = TextEditingController(text: widget.title);
    _timeController = TextEditingController(text: widget.time);
    _dateController = TextEditingController(text: widget.date);

    super.initState();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _timeController.dispose();
    _titleController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive().init(constraints: constraints);
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(1.6 * Responsive().widthConfige),
                  child: Column(
                    children: [
                      heightSizedBox(6),
                      Text(
                        'Add new Task',
                        style: TextStyle(
                            fontSize: 2.5 * Responsive().textConfige,
                            fontWeight: FontWeight.bold),
                      ),
                      heightSizedBox(1),
                      const Divider(
                        color: Colors.grey,
                        indent: 3,
                        endIndent: 3,
                        thickness: 1,
                      ),
                      heightSizedBox(2),
                      TextField(
                        controller: _titleController,
                        decoration:
                            const InputDecoration(hintText: 'Title of task'),
                      ),
                      heightSizedBox(3),
                      TextField(
                        controller: _taskController,
                        decoration:
                            const InputDecoration(hintText: 'Description'),
                      ),
                      heightSizedBox(5),
                      TextFormField(
                        controller: _timeController,
                        decoration: InputDecoration(
                          hintText: 'select Time',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.timer_sharp),
                            onPressed: () {
                              _showTime(context);
                            },
                          ),
                        ),
                      ),
                      heightSizedBox(2),
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          hintText: 'select Date',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () {
                              _showDate(context);
                            },
                          ),
                        ),
                      ),
                      heightSizedBox(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 35 * Responsive().widthConfige,
                            height: 5 * Responsive().heightConfige,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(homeRoute);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                textStyle: const TextStyle(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          widthSizedBox(10),
                          SizedBox(
                            width: 35 * Responsive().widthConfige,
                            height: 5 * Responsive().heightConfige,
                            child: ElevatedButton(
                              onPressed: () async {
                                _addNewTask();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Create'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
