import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final taskBox = Hive.box<TaskModel>('tasks');
      return taskBox.values.toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      final taskBox = Hive.box<TaskModel>('tasks');
      await taskBox.put(task.id, task);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      final taskBox = Hive.box<TaskModel>('tasks');
      await taskBox.put(task.id, task);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final taskBox = Hive.box<TaskModel>('tasks');
      await taskBox.delete(id);
    } catch (e) {
      throw CacheException();
    }
  }
}
