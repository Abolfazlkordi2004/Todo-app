import 'package:flutter/material.dart';

@immutable
abstract class TaskState {
  final bool isLoading;
  final String textLoading;
  const TaskState(
      {required this.isLoading, this.textLoading = 'در حال بارگذاری'});
}

class TaskLoadingState extends TaskState {
  final Exception? exception;
  const TaskLoadingState({
    bool isLoading = false,
    this.exception,
  }) : super(isLoading: false);
}

class HomeAppState extends TaskState {
  final Exception? exception;
  const HomeAppState({
    bool isLoading = false,
    this.exception,
  }) : super(isLoading: false);
}

class TaskLoadedState extends TaskState {
  final Exception? exception;
  final List<List<String>> tasks;
  const TaskLoadedState({
    bool isLoading = false,
    this.exception,
    required this.tasks,
  }) : super(isLoading: false);
}

class TaskUpdatedState extends TaskState {
  final Exception? exception;
  const TaskUpdatedState({
    bool isLoading = false,
    this.exception,
  }) : super(isLoading: false);
}

class TaskErrorState extends TaskState {
  final String message;
  final Exception? exception;
  const TaskErrorState({
    bool isLoading = false,
    this.exception,
    required this.message,
  }) : super(isLoading: false);
}
