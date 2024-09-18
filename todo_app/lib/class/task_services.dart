import 'dart:async';

class TaskServices {
  final List<List<String>> _tasks = [];
  final StreamController<List<List<String>>> _taskStreamController =
      StreamController<List<List<String>>>.broadcast();

  Stream<List<List<String>>> get taskStream => _taskStreamController.stream;

  void addTask(List<String> task) {
    _tasks.addAll([task]);
    _taskStreamController.add(_tasks);
  }

  void dispose() {
    _taskStreamController.close();
  }
}