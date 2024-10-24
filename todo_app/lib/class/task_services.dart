import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskServices {
  final List<List<String>> tasks = [];
  final StreamController<List<List<String>>> _taskStreamController =
      StreamController<List<List<String>>>.broadcast();
  Stream<List<List<String>>> get taskStream => _taskStreamController.stream;

  TaskServices() {
    loadTasks();
  }

  void addTask(List<String> task) async {
    tasks.add(task);
    _taskStreamController.add(tasks);
    await saveTasks();
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs.getStringList('tasks');
    tasks.clear();
    if (savedTasks != null) {
      for (String task in savedTasks) {
        tasks.add(List<String>.from(json.decode(task)));
      }
      _taskStreamController.add(tasks);
    }
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStringList =
        tasks.map((task) => json.encode(task)).toList();
    await prefs.setStringList('tasks', taskStringList);
  }

  Future<void> removeTasks(List<String> removedTask) async {
    tasks.removeWhere((task) =>
        task[0] == removedTask[0] &&
        task[1] == removedTask[1] &&
        task[2] == removedTask[2] &&
        task[3] == removedTask[3]);
    _taskStreamController.add(tasks);
    await saveTasks();
  }

  Future<void> updateTask(
      List<String> oldTask, List<String> updatedTask) async {
    int index = tasks.indexWhere((task) =>
        task[0] == oldTask[0] &&
        task[1] == oldTask[1] &&
        task[2] == oldTask[2] &&
        task[3] == oldTask[3]);

    if (index != -1) {
      tasks[index] = updatedTask;
      _taskStreamController.add(tasks);
      await saveTasks();
    }
  }

  void dispose() {
    _taskStreamController.close();
  }
}
