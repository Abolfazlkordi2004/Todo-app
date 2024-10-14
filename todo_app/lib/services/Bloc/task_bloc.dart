import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/services/Bloc/task_event_bloc.dart';
import 'package:todo_app/services/Bloc/task_state_bloc.dart';


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskServices taskServices;

  TaskBloc(this.taskServices) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoadInProgress());
      try {
        final tasks = await taskServices.getTasks(); // Create a method in TaskServices to fetch tasks
        emit(TaskLoadSuccess(tasks));
      } catch (_) {
        emit(TaskLoadFailure());
      }
    });

    on<AddTask>((event, emit) async {
      taskServices.addTask(event.task);
      add(LoadTasks());
    });

    on<UpdateTask>((event, emit) async {
      taskServices.updateTask(event.oldTaskText, event.updatedTaskText);
      add(LoadTasks());
    });

    on<RemoveTask>((event, emit) async {
      await taskServices.removeTasks(event.task);
      add(LoadTasks());
    });
  }
}
