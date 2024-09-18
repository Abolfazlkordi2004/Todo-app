import 'dart:async';

class TaskServices {
  final List<List<String>> _tasks = [];
  final StreamController<Iterable> _taskStreamController =
      StreamController<List<List<String>>>.broadcast();

  Stream get taskStream => _taskStreamController.stream;

  void addTask(List<String> task) {
    _tasks.addAll([task]);
    _taskStreamController.add(_tasks);
  }

  void dispose() {
    _taskStreamController.close();
  }
}
