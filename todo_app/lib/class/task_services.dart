import 'dart:async';
 

class TaskServices {
  final StreamController<List<String>> _taskController =
      StreamController<List<String>>.broadcast();

  Stream<List<String>> get taskStream => _taskController.stream;

  void addTasks(List<String> tasks) {
    _taskController.sink.add(tasks);
  }

  void dispose() {
    _taskController.close();
  }
}
