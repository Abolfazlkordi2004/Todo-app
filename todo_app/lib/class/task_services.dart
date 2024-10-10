import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskServices {
  final List<List<String>> _tasks = [];
  final StreamController<List<List<String>>> _taskStreamController =
      StreamController<List<List<String>>>.broadcast();
  Stream<List<List<String>>> get taskStream => _taskStreamController.stream;

  TaskServices() {
    _loadTasks();  
  }

  void addTask(List<String> task) async {
    _tasks.add(task);
    _taskStreamController.add(_tasks);
    await _saveTasks();  
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs.getStringList('tasks');

    if (savedTasks != null) {
      for (String task in savedTasks) {
        _tasks.add(List<String>.from(json.decode(task)));
      }
      _taskStreamController.add(_tasks);
    }
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStringList =
        _tasks.map((task) => json.encode(task)).toList();
    await prefs.setStringList('tasks', taskStringList);
  }

 
  Future<void> removeTasks(List<String> removedTask) async {
    _tasks.removeWhere((task) =>
        task[0] == removedTask[0] &&
        task[1] == removedTask[1] &&
        task[2] == removedTask[2] &&
        task[3] == removedTask[3]);
    _taskStreamController.add(_tasks);
    await _saveTasks();
  }

  void dispose() {
    _taskStreamController.close();
  }
}
