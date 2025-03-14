part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<MyTask> allTasks;
  final List<MyTask> filteredTasks;
  final bool? statusFilter;
  final String? categoryFilter;

  TaskLoaded(
    this.allTasks,
    this.filteredTasks,
    this.statusFilter,
    this.categoryFilter,
  );

  @override
  List<Object?> get props =>
      [allTasks, filteredTasks, statusFilter, categoryFilter];
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);

  @override
  List<Object> get props => [message];
}
