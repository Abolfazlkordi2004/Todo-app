import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/helper/loading/loading_screen.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_bloc.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_event.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_state.dart';
import 'package:todo_app/utilities.dart/dialogs/empty_create_view_dialog.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class UpdateTaskView extends StatefulWidget {
  final TaskServices taskServices;
  final String? title;
  final String? taskText;
  final String? time;
  final String? date;

  const UpdateTaskView({
    super.key,
    required this.taskServices,
    this.title,
    this.taskText,
    this.time,
    this.date,
  });

  @override
  State<UpdateTaskView> createState() => _UpdateTaskViewState();
}

class _UpdateTaskViewState extends State<UpdateTaskView> {
  late TextEditingController _titleController;
  late TextEditingController _taskController;
  late TextEditingController _timeController;
  late TextEditingController _dateController;

  TimeOfDay nowTime = TimeOfDay.now();
  DateTime nowDate = DateTime.now();

  Future<void> _showTime(BuildContext context) async {
    var time = await showPersianTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (context.mounted) {
      var persianTime = time?.persianFormat(context);
      if (time != null) {
        // _timeController.text = '${time.hour}:${time.minute}';
        _timeController.text = '$persianTime';
      }
    }
  }

  Future<void> _showDate(BuildContext context) async {
    Jalali? date = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1400),
      lastDate: Jalali(1500),
    );

    if (date != null) {
      _dateController.text = date.formatFullDate();
    }
  }

  void updatedTask() {
    String title = _titleController.text;
    String task = _taskController.text;
    String time = _timeController.text;
    String date = _dateController.text;

    if (title.isNotEmpty &&
        task.isNotEmpty &&
        time.isNotEmpty &&
        date.isNotEmpty) {
      List<String> updatedTask = [title, task, time, date];
      List<String> oldTask = [
        widget.title ?? '',
        widget.taskText ?? '',
        widget.time ?? '',
        widget.date ?? ''
      ];

      context.read<TaskBloc>().add(UpdateTaskEvent(oldTask, updatedTask));
    } else {
      showEmptyTextDialog(context, 'لطفا همه مقادیر را پر کنید');
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
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskUpdatedState || state is TaskLoadedState) {
          Navigator.of(context).pop(); // Navigate back only after state update
        }
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: 'لطفا صبر کنید');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
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
                            'ویرایش هدف',
                            style: TextStyle(
                              fontSize: 2.5 * Responsive().textConfige,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          heightSizedBox(1),
                          const Divider(
                            color: Colors.grey,
                            indent: 3,
                            endIndent: 3,
                            thickness: 1,
                          ),
                          heightSizedBox(2),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: _titleController,
                              decoration:
                                  const InputDecoration(hintText: 'موضوع'),
                            ),
                          ),
                          heightSizedBox(3),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: _taskController,
                              decoration:
                                  const InputDecoration(hintText: 'توضیحات'),
                            ),
                          ),
                          heightSizedBox(5),
                          TextFormField(
                            controller: _timeController,
                            decoration: InputDecoration(
                              hintText: 'زمان ',
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
                              hintText: 'تاریخ ',
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
                                    textStyle:
                                        const TextStyle(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(width: 1.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('لغو'),
                                ),
                              ),
                              widthSizedBox(10),
                              SizedBox(
                                width: 35 * Responsive().widthConfige,
                                height: 5 * Responsive().heightConfige,
                                child: ElevatedButton(
                                  onPressed: () {
                                    updatedTask();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('ویرایش'),
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
      },
    );
  }
}
