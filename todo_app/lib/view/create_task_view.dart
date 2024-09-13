import 'package:flutter/material.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';

class CreateTaskView extends StatefulWidget {
  final TaskServices taskServices;

  const CreateTaskView({super.key, required this.taskServices});

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

  Future<void> _showTime(BuildContext) async {
    var time = await showTimePicker(
      context: context,
      initialTime: nowTime,
    );

    if (time != null) {
      _timeController.text = '${time.hour}:${time.minute}';
    }
  }

  Future<void> _showDate(BuildContext) async {
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

  void _addNewTask() {
    String task = _taskController.text;
    String title = _titleController.text;
    String time = _timeController.text;
    String date = _dateController.text;

    if (task.isNotEmpty &&
        title.isNotEmpty &&
        time.isNotEmpty &&
        date.isNotEmpty) {
      widget.taskServices.addTask([title, task, time, date]);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _taskController = TextEditingController();
    _titleController = TextEditingController();
    _timeController = TextEditingController();
    _dateController = TextEditingController();
 
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
    return Scaffold(
      body: SingleChildScrollView(
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
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                    decoration: const InputDecoration(hintText: 'Title of task'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                        hintText:'Description'),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      hintText: 'select Time',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.5),
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
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.5),
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
                            textStyle: const TextStyle(color: Colors.black),
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
                            _addNewTask();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(color: Colors.black),
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
  }
}
