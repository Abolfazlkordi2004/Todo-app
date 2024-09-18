import 'package:flutter/material.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/services/auth/auth_service.dart';
import 'package:todo_app/services/cloud/cloud_task.dart';
import 'package:todo_app/services/cloud/firebase_cloud_storage.dart';
import 'package:todo_app/utilities.dart/generics/get_arguman.dart';

// ignore: must_be_immutable
class CreateTaskView extends StatefulWidget {
  String? title;
  String? taskText;
  String? time;
  String? date;

  CreateTaskView({
    super.key,
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

  CloudTask? _task;
  late FirebaseCloudStorage taskServices;

  void _taskControllerListner() async {
    final task = _task;
    if (task == null) {
      return;
    } else {
      final title = _titleController.text;
      final textTask = _taskController.text;
      final time = _timeController.text;
      final date = _dateController.text;
      await taskServices.updateTask(
        documentId: task.documentId,
        title: title,
        text: textTask,
        time: time,
        date: date,
      );
    }
  }

  void _setupTaskController() {
    _titleController.addListener(_taskControllerListner);
    _taskController.addListener(_taskControllerListner);
    _timeController.addListener(_taskControllerListner);
    _dateController.addListener(_taskControllerListner);
    _titleController.removeListener(_taskControllerListner);
    _taskController.removeListener(_taskControllerListner);
    _timeController.removeListener(_taskControllerListner);
    _dateController.removeListener(_taskControllerListner);
  }

  Future<CloudTask> createOrGetExistingTask(BuildContext context) async {
    final widgetTask = context.getArguman<CloudTask>();

    if (widgetTask != null) {
      _task = widgetTask;
      _titleController.text = widgetTask.title;
      _taskController.text = widgetTask.text;
      _timeController.text = widgetTask.time;
      _dateController.text = widgetTask.date;
      return widgetTask;
    }

    final existingTask = _task;
    if (existingTask != null) {
      return existingTask;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newTask = await taskServices.createNewTask(ownerUserId: userId);
    _task = newTask;
    return newTask;
  }

  void _deleteTaskIfTaskIsEmpty() {
    final task = _task;
    if (_titleController.text.isEmpty &&
        _taskController.text.isEmpty &&
        _timeController.text.isEmpty &&
        _dateController.text.isEmpty &&
        task != null) {
      taskServices.deleteTask(documentId: task.documentId);
    }
  }

  void _saveTaskIfTaskNotEmpty() async {
    final task = _task;
    final title = _titleController.text;
    final textTask = _taskController.text;
    final time = _timeController.text;
    final date = _dateController.text;
    if (task != null &&
        title.isNotEmpty &&
        textTask.isNotEmpty &&
        time.isNotEmpty &&
        date.isNotEmpty) {
      await taskServices.updateTask(
          documentId: task.documentId,
          title: title,
          text: textTask,
          time: time,
          date: date);
    }
  }

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

  // void _addNewTask() async {
  //   String task = _taskController.text;
  //   String title = _titleController.text;
  //   String time = _timeController.text;
  //   String date = _dateController.text;

  //   if (task.isNotEmpty &&
  //       title.isNotEmpty &&
  //       time.isNotEmpty &&
  //       date.isNotEmpty) {
  //   } else if (task.isEmpty || title.isEmpty || time.isEmpty || date.isEmpty) {
  //     await showEmptyTextDialog(context, 'Please fill all fields');
  //   }
  // }

  @override
  void initState() {
    _taskController = TextEditingController(text: widget.taskText);
    _titleController = TextEditingController(text: widget.title);
    _timeController = TextEditingController(text: widget.time);
    _dateController = TextEditingController(text: widget.date);
    taskServices = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _timeController.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _saveTaskIfTaskNotEmpty();
    _deleteTaskIfTaskIsEmpty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: createOrGetExistingTask(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTaskController();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          const Text(
                            'Add new Task',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: Colors.grey,
                            indent: 3,
                            endIndent: 3,
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                                hintText: 'Title of task'),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _taskController,
                            decoration:
                                const InputDecoration(hintText: 'Description'),
                          ),
                          const SizedBox(height: 50),
                          TextFormField(
                            controller: _timeController,
                            decoration: InputDecoration(
                              hintText: 'select Time',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.5),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.timer_sharp),
                                onPressed: () {
                                  _showTime(context);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              hintText: 'select Date',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.5),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.date_range),
                                onPressed: () {
                                  _showDate(context);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(homeRoute);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    textStyle:
                                        const TextStyle(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    _saveTaskIfTaskNotEmpty();
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade800,
                                    foregroundColor: Colors.white,
                                    textStyle:
                                        const TextStyle(color: Colors.black),
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
              );

            default:
              return const LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
