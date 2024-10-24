import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/class/task_services.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskServices taskServices;

  TaskBloc(this.taskServices) : super(const TaskLoadingState()) {
    on<UpdateTaskEvent>(
      (event, emit) async {
        emit(const TaskLoadingState(isLoading: true));

        await taskServices.updateTask(event.oldTask, event.updatedTask);

        final updatedTasks = taskServices.tasks;
        emit(TaskLoadedState(tasks: updatedTasks));
      },
    );
    on<LoadTasksEvent>(
      (event, emit) async {
        emit(const TaskLoadingState(isLoading: true));
        await taskServices.loadTasks();
        emit(TaskLoadedState(tasks: taskServices.tasks));
      },
    );
    on<AddTaskEvent>(
      (event, emit) {
        emit(const TaskLoadingState(isLoading: true));

        taskServices.addTask(event.task);
        emit(TaskLoadedState(tasks: taskServices.tasks));
      },
    );
    on<DeleteTaskEvent>(
      (event, emit) async {
        emit(const TaskLoadingState(isLoading: true));

        await taskServices.removeTasks(event.task);
        emit(TaskLoadedState(tasks: taskServices.tasks));
      },
    );
  }
}
