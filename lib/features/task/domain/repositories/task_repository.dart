import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<MyTask>>> getTasks();
  Future<Either<Failure, void>> addTask(MyTask task);
  Future<Either<Failure, void>> updateTask(MyTask task);
  Future<Either<Failure, void>> deleteTask(String id);
}
