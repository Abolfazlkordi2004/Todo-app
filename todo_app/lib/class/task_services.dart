import 'dart:async';

class TaskServices {
  final List<List<String>> _tasks = [];
  final StreamController<List<List<String>>> _taskStreamController =
      StreamController<List<List<String>>>.broadcast();

  Stream<List<List<String>>> get taskStream => _taskStreamController.stream;

  int get taskCount => _tasks.length;

  void addTask(List<String> task) {
    _tasks.addAll([task]);
    _taskStreamController.add(_tasks);
    print(_tasks);
    print(taskCount);
  }

  void dispose() {
    _taskStreamController.close();
  }
}
