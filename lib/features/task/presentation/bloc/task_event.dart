part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String title;
  final String description;
  final String category;

  AddTaskEvent({
    required this.title,
    required this.description,
    required this.category,
  });

  @override
  List<Object> get props => [title, description, category];
}

class UpdateTaskEvent extends TaskEvent {
  final MyTask task;

  UpdateTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;

  DeleteTaskEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FilterTasks extends TaskEvent {
  final bool? status;
  final String? category;

  FilterTasks({this.status, this.category});

  @override
  List<Object?> get props => [status, category];
}
