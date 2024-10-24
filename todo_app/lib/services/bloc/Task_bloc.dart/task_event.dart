import 'package:flutter/material.dart';

@immutable
abstract class TaskEvent {
  const TaskEvent();
}

class LoadTasksEvent extends TaskEvent {
  final List<String> task;
  const LoadTasksEvent(this.task);
}

class HomeAppEvent extends TaskEvent {
  const HomeAppEvent();
}

class AddTaskEvent extends TaskEvent {
  final List<String> task;
  const AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final List<String> oldTask;
  final List<String> updatedTask;
  const UpdateTaskEvent(this.oldTask, this.updatedTask);
}

class DeleteTaskEvent extends TaskEvent {
  final List<String> task;
  const DeleteTaskEvent(this.task);
}

class SearchTaskEvent extends TaskEvent {
  final String query;
  const SearchTaskEvent(this.query);
}
