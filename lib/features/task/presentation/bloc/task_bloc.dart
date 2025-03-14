import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<FilterTasks>(_onFilterTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await getTasks();
    result.fold(
      (failure) => emit(TaskError('Failed to load tasks')),
      (tasks) => emit(TaskLoaded(tasks, tasks, null, null)),
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final task = MyTask(
        id: const Uuid().v4(),
        title: event.title,
        description: event.description,
        category: event.category,
        isCompleted: false,
      );

      final result = await addTask(task);

      // Using await to ensure we wait for the operation to complete
      await result.fold(
        (failure) async {
          emit(TaskError('Failed to add task'));
        },
        (_) async {
          final tasksResult = await getTasks();
          tasksResult.fold(
            (failure) => emit(TaskError('Failed to reload tasks')),
            (tasks) => emit(TaskLoaded(
              tasks,
              _applyFilters(tasks, currentState.statusFilter, currentState.categoryFilter),
              currentState.statusFilter,
              currentState.categoryFilter,
            )),
          );
        },
      );
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final result = await updateTask(event.task);

      // Using await to ensure we wait for the operation to complete
      await result.fold(
        (failure) async {
          emit(TaskError('Failed to update task'));
        },
        (_) async {
          final tasksResult = await getTasks();
          tasksResult.fold(
            (failure) => emit(TaskError('Failed to reload tasks')),
            (tasks) => emit(TaskLoaded(
              tasks,
              _applyFilters(tasks, currentState.statusFilter, currentState.categoryFilter),
              currentState.statusFilter,
              currentState.categoryFilter,
            )),
          );
        },
      );
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final result = await deleteTask(event.id);

      // Using await to ensure we wait for the operation to complete
      await result.fold(
        (failure) async {
          emit(TaskError('Failed to delete task'));
        },
        (_) async {
          final tasksResult = await getTasks();
          tasksResult.fold(
            (failure) => emit(TaskError('Failed to reload tasks')),
            (tasks) => emit(TaskLoaded(
              tasks,
              _applyFilters(tasks, currentState.statusFilter, currentState.categoryFilter),
              currentState.statusFilter,
              currentState.categoryFilter,
            )),
          );
        },
      );
    }
  }

  void _onFilterTasks(FilterTasks event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      emit(TaskLoaded(
        currentState.allTasks,
        _applyFilters(currentState.allTasks, event.status, event.category),
        event.status,
        event.category,
      ));
    }
  }

  List<MyTask> _applyFilters(List<MyTask> tasks, bool? status, String? category) {
    List<MyTask> filteredTasks = List.from(tasks);

    if (status != null) {
      filteredTasks = filteredTasks.where((task) => task.isCompleted == status).toList();
    }

    if (category != null && category.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) => task.category == category).toList();
    }

    return filteredTasks;
  }
}
