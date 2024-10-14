import 'package:equatable/equatable.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoadInProgress extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final List<List<String>> tasks;

  const TaskLoadSuccess(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskLoadFailure extends TaskState {}
