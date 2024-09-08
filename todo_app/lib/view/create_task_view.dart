import 'package:flutter/material.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/constant/username.dart';

class CreateTaskView extends StatefulWidget {
  const CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  late TextEditingController _taskController;
  late TextEditingController _timeController;
  late TextEditingController _dateContoller;

  DateTime dateNow = DateTime.now();
  TimeOfDay timeNow = TimeOfDay.now();

  Future<void> selectTime(
    BuildContext context,
  ) async {
    var time = await showTimePicker(
      context: context,
      initialTime: timeNow,
    );

    if (time != null) {
      _timeController.text = '${time.hour}:${time.minute}';
      setState(() {});
    }
  }

  Future<void> selectDate(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: dateNow,
      firstDate: dateNow,
      lastDate: DateTime(2030),
    );

    if (date != null) {
      _dateContoller.text = date.toLocal().toString().split(' ')[0];
      setState(() {});
    }
  }

  @override
  void initState() {
    _taskController = TextEditingController();
    _timeController = TextEditingController();
    _dateContoller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _timeController.dispose();
    _dateContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Add new task',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  hintText: 'Title of Task',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  hintText: 'What do you want to do?',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  hintText: 'Time',
                  labelStyle: const TextStyle(color: Colors.black),
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
                    onPressed: () {
                      selectTime(
                        context,
                      );
                    },
                    icon: const Icon(Icons.timer_sharp),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _dateContoller,
                decoration: InputDecoration(
                  hintText: 'Date',
                  labelStyle: const TextStyle(color: Colors.black),
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
                    onPressed: () {
                      selectDate(context);
                    },
                    icon: const Icon(Icons.date_range),
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
                    width: 100,
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
                          side:
                              const BorderSide(color: Colors.black, width: 1.5),
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
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        taskList?.add(_taskController.text);
                        Navigator.of(context).pushNamed(homeRoute);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Create'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
