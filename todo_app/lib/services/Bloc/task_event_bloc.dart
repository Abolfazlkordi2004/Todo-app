import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final List<String> task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final String oldTaskText;
  final List<String> updatedTaskText;

  const UpdateTask(this.oldTaskText, this.updatedTaskText);

  @override
  List<Object?> get props => [oldTaskText, updatedTaskText];
}

class RemoveTask extends TaskEvent {
  final List<String> task;

  const RemoveTask(this.task);

  @override
  List<Object?> get props => [task];
}
