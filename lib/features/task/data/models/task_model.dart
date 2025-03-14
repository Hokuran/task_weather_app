import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends MyTask {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String title;

  @override
  @HiveField(2)
  final String description;

  @override
  @HiveField(3)
  final String category;

  @override
  @HiveField(4)
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isCompleted,
  }) : super(
          id: id,
          title: title,
          description: description,
          category: category,
          isCompleted: isCompleted,
        );

  factory TaskModel.fromTask(MyTask task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      category: task.category,
      isCompleted: task.isCompleted,
    );
  }
}
